// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is auto-generated by the Ballerina OpenAPI tool.

import ballerina/http;

public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config =  {}, string serviceUrl = "http://localhost:8080/") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                httpClientConfig.http1Settings = {...settings};
            }
            if config.http2Settings is http:ClientHttp2Settings {
                httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
            }
            if config.cache is http:CacheConfig {
                httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
            }
            if config.responseLimits is http:ResponseLimitConfigs {
                httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
            }
            if config.secureSocket is http:ClientSecureSocket {
                httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
            }
            if config.proxy is http:ProxyConfig {
                httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
            }
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }
    # 
    #
    # + return - Ok 
    resource isolated function get Programs() returns Program[]|error {
        string resourcePath = string `/Programs`;
        Program[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # 
    #
    # + return - Created 
    resource isolated function post Programs(Program payload) returns http:Response|error {
        string resourcePath = string `/Programs`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function get Programs/[string progCode]() returns Program|error {
        string resourcePath = string `/Programs/${getEncodedUri(progCode)}`;
        Program response = check self.clientEp->get(resourcePath);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function put Programs/[string progCode](Program payload) returns http:Response|error {
        string resourcePath = string `/Programs/${getEncodedUri(progCode)}`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function get Programs/NQF/[string nqfLevel]() returns Program[]|error {
        string resourcePath = string `/Programs/NQF/${getEncodedUri(nqfLevel)}`;
        Program[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function get courses() returns Course[]|error {
        string resourcePath = string `/courses`;
        Course[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # 
    #
    # + return - Created 
    resource isolated function post courses(Course payload) returns http:Response|error {
        string resourcePath = string `/courses`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function get courses/[string courseCode]() returns Course|error {
        string resourcePath = string `/courses/${getEncodedUri(courseCode)}`;
        Course response = check self.clientEp->get(resourcePath);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function put courses/[string courseCode](Course payload) returns http:Response|error {
        string resourcePath = string `/courses/${getEncodedUri(courseCode)}`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function delete courses/[string courseCode]() returns Course|error {
        string resourcePath = string `/courses/${getEncodedUri(courseCode)}`;
        Course response = check self.clientEp-> delete(resourcePath);
        return response;
    }
    # 
    #
    # + return - Ok 
    resource isolated function delete Programs/[string progCode]() returns Program|error {
        string resourcePath = string `/Programs/${getEncodedUri(progCode)}`;
        Program response = check self.clientEp-> delete(resourcePath);
        return response;
    }
}
