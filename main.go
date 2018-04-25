package main

import (
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"os"
	"strconv"
)

func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	featureFlag, err := strconv.ParseBool(os.Getenv("FEATURE_FLAG"))

	return events.APIGatewayProxyResponse{
		Body: fmt.Sprintf("Hello world!"),
		Headers: map[string]string{
			"FeatureFlag": strconv.FormatBool(featureFlag),
		},
		StatusCode: 200,
	}, err
}

func main() {
	lambda.Start(Handler)
}
