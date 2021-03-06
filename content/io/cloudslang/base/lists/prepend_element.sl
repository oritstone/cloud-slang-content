#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: pre-pends an element to a list of strings
#! @input list: list in which to pre-pend the element - Example: '1,2,3,4,5,6'
#! @input element: element to pre-pend to the list - Example: '7'
#! @input delimiter: optional - the list delimiter. delimiter can be empty string
#!                   Default: ','
#! @output response: 'success' or 'failure'
#! @output return_result: the new list or an error message otherwise
#! @output return_code: 0 if success, -1 if failure
#! @result SUCCESS: the new list was retrieved with success
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: prepend_element

  inputs:
    - list
    - element
    - delimiter:
        required: false
        default: ','

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.6'
    class_name: io.cloudslang.content.actions.ListPrependerAction
    method_name: prependElement

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
