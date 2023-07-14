serviceAccount:
  create: ${create}
  name: ${csi-account-name}
  namespace: ${namespace}
  labels:
    app.kubernetes.io/name: ${efs-csi-driver-release-name}
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${aws-account-id}:role/${csi-role-name}
    meta.helm.sh/release-name: ${efs-csi-driver-release-name}