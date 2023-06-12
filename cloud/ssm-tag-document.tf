resource "aws_ssm_document" "volume_tag" {
  name            = "tag-volumes"
  document_format = "YAML"
  document_type   = "Automation"
  target_type   =   "/AWS::EC2::Volume"

  content = <<DOC
schemaVersion: '0.3'
mainSteps:
  - name: createTags
    action: 'aws:createTags'
    maxAttempts: 3
    onFailure: Abort
    inputs:
      ResourceType: EC2
      ResourceIds:
        - ${data.aws_ebs_volume.test.id}
      Tags:
        - Key: Name
          Value: migrated-volume
DOC
}

# resource "aws_ssm_association" "run_document" {
#   name = aws_ssm_document.volume_tag.name

#   targets {
#     key    = "Name"
#     values = ["Migrated-webserver-Server"]
#   }
# }