namespace: io.cloudslang.docker.monitoring.mysql

imports:
  mysql: io.cloudslang.docker.monitoring.mysql
  containers_examples: io.cloudslang.docker.containers.examples
  maintenance: io.cloudslang.docker.maintenance
  utils: io.cloudslang.base.flow_control
  cmd: io.cloudslang.base.cmd

flow:
  name: test_report_mysql_status

  inputs:
    - docker_host
    - docker_port:
        required: false
    - docker_username
    - docker_password
    - mysql_username
    - mysql_password
    - email_host
    - email_username
    - email_port
    - email_sender
    - email_password
    - email_recipient

  workflow:
    - pre_test_cleanup:
        do:
         maintenance.clear_host:
           - docker_host
           - port: ${ docker_port }
           - docker_username
           - docker_password
        navigate:
         - SUCCESS: run_postfix
         - FAILURE: MACHINE_IS_NOT_CLEAN

    - run_postfix:
        do:
          cmd.run_command:
            - command: ${ 'docker run -p ' + email_port + ':' + '25' + ' -e maildomain=mail.example.com -e smtp_user=user:pwd --name postfix -d catatnight/postfix' }

    - wait_for_postfix:
        do:
          utils.sleep:
            - seconds: '10'

    - start_mysql_container:
        do:
          containers_examples.create_db_container:
            - host: ${ docker_host }
            - port: ${ docker_port }
            - username: ${ docker_username }
            - password: ${ docker_password }
        navigate:
          - SUCCESS: wait_for_mysql
          - FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - wait_for_mysql:
        do:
          utils.sleep:
            - seconds: '20'

    - report_mysql_status:
        do:
          mysql.report_mysql_status:
            - container: "mysqldb"
            - docker_host
            - docker_port
            - docker_username
            - docker_password
            - mysql_username
            - mysql_password
            - email_host
            - email_username
            - email_password
            - email_port
            - email_sender
            - email_recipient
        navigate:
          - SUCCESS: post_test_cleanup
          - FAILURE: FAILURE

    - post_test_cleanup:
        do:
         maintenance.clear_host:
           - docker_host
           - port: ${ docker_port }
           - docker_username
           - docker_password
        navigate:
         - SUCCESS: postfix_cleanup
         - FAILURE: MACHINE_IS_NOT_CLEAN

    - postfix_cleanup:
        do:
         cmd.run_command:
           - command: "docker rm -f postfix && docker rmi catatnight/postfix"
        navigate:
         - SUCCESS: SUCCESS
         - FAILURE: FAIL_TO_CLEAN_POSTFIX

  results:
    - SUCCESS
    - FAIL_TO_CLEAN_POSTFIX
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - FAILURE
