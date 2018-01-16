package main

import (
	"bufio"
	"flag"
	"net"
	"os"
	"log"
)

var logger log.Logger

func scanFile(f *os.File, conn net.Conn) {
	scanner := bufio.NewScanner(f)

	for scanner.Scan() {
		line := scanner.Text()
		conn.Write([]byte(line))
	}

	if err := scanner.Err(); err != nil {
		logger.Fatalf("Error reading input: %s", err)
	}
}

func main() {
	logger := log.New(os.Stderr, "", log.LstdFlags|log.Lshortfile)
	address := flag.String("address", "127.0.0.1:5555", "The target address.")

	flag.Parse()
	files := flag.Args()

	remoteAddr, err := net.ResolveUDPAddr("udp", *address)
	if err != nil {
		logger.Fatalf("Couldn't resolve target address: %s", err)
	}

	conn, err := net.DialUDP("udp", nil, remoteAddr)
	defer conn.Close()
	if err != nil {
		logger.Fatalf("Failed to acquire connection from pool: %s", err)
	}

	if len(files) > 0 {
		for _, file_name := range files {
			f, err := os.Open(file_name)
			defer f.Close()

			if err != nil {
				logger.Fatalf("Could not open file %s", file_name)
				continue
			}
			scanFile(f, conn)
		}
	} else {
		log.Println("No input files provided. Using stdin...")
		scanFile(os.Stdin, conn)
	}
}
