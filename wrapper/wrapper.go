package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"os"
	"os/exec"
	"time"
)

// Program which kills ehtminer after it hangs with SIGSEGV.
// To fix https://github.com/ethereum-mining/ethminer/issues/1895

func run() error {
	cmd := exec.Command("/usr/local/bin/ethminer", os.Args[1:]...)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return err
	}
	stderr, err := cmd.StderrPipe()
	if err != nil {
		return err
	}
	err = cmd.Start()
	if err != nil {
		return err
	}
	go io.Copy(os.Stdout, stdout)
	scanner := bufio.NewScanner(stderr)
	for scanner.Scan() {
		b := scanner.Bytes()
		os.Stderr.Write(b)
		os.Stderr.Write([]byte("\n"))
		if bytes.Contains(b, []byte("SIGSEGV")) {
			time.AfterFunc(time.Second, func() {
				cmd.Process.Kill()
			})
		}
	}
	cmd.Wait()
	return nil
}

func main() {
	err := run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error executing ethminer: %v\n", err)
		os.Exit(1)
	}
}
