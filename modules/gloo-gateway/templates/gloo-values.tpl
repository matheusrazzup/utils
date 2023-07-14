gatewayProxies:
        gatewayProxy:
            service:
                extraAnnotations:
                    service.beta.kubernetes.io/aws-load-balancer-internal: true
                    service.beta.kubernetes.io/aws-load-balancer-type: nlb
                    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "instance"
                    service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
accessLogger:
    enabled: true
global:
    extensions:
        extAuth:
            extauthzServerRef:
                name: orgs-openpolicyagent-9191
                namespace: gloo-system
            requestTimeout: "1s"
settings:
    watchNamespaces: [orgs, gloo-system, stacks, runtimes]
    aws:
        enableServiceAccountCredentials: true
        stsCredentialsRegion: ${aws_region}

gateway:
    proxyServiceAccount:
        extraAnnotations:
            eks.amazonaws.com/role-arn: arn:aws:iam::${account_id}:role/lambda-eks

discovery:
    serviceAccount:
        extraAnnotations:
            eks.amazonaws.com/role-arn: arn:aws:iam::${account_id}:role/lambda-eks
