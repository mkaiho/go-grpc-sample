package main

import (
	"context"
	"log"
	"time"

	"github.com/mkaiho/go-grpc-sample/libs"
	pb "github.com/mkaiho/go-grpc-sample/proto/userspb"
	"google.golang.org/grpc"
)

const (
	defaultAddress = "localhost"
	defaultPort    = "3000"
)

func main() {
	address := libs.GetEnvLoader().GetValue("API_REQUEST_HOST")
	if address == "" {
		address = defaultAddress
	}
	port := libs.GetEnvLoader().GetValue("API_REQUEST_PORT")
	if port == "" {
		port = defaultPort
	}

	conn, err := grpc.Dial(address+":"+port, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewUserManagerClient(conn)
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	user, err := c.Find(ctx, &pb.FindUserRequest{Id: "a6217596-f048-88ad-2ce8-02860c05e96f"})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("User: %s", user)
}
