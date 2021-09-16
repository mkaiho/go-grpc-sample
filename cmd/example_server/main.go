package main

import (
	"context"
	"log"
	"net"

	pb "github.com/mkaiho/go-grpc-sample/proto/userspb"
	"google.golang.org/grpc"
)

const (
	port = ":3000"
)

type server struct {
	pb.UnimplementedUserManagerServer
}

func (s *server) Find(ctx context.Context, in *pb.FindUserRequest) (*pb.FindUserResponse, error) {
	user := &pb.FindUserResponse{
		Id:   in.GetId(),
		Name: "Alice",
	}
	return user, nil
}

func main() {
	listener, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v\n", err)
		return
	}

	grpcSrv := grpc.NewServer()
	pb.RegisterUserManagerServer(grpcSrv, &server{})
	log.Printf("Listening on %v", listener.Addr())

	err = grpcSrv.Serve(listener)
	if err != nil {
		log.Fatalf("failed to serve: %v\n", err)
		return
	}
}
