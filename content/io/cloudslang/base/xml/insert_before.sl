#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Appends a child to an XML element.
#!
#! @input xml_document: XML string or file to insert element in
#! @input xml_document_source: xml document type
#!                             Default: xmlStirng
#!                             Accepted values: xmlString, xmlPath
#! @input xpath_element_query: XPATH query that results in an element or element
#!                             list, where element will be inserted before
#! @input xml_element: element to insert
#! @input secure_processing: whether to use secure processing
#!                           optional
#!                           default: false
#! @output result_xml: given XML with element inserted
#! @output return_result: exception in case of failure, success message otherwise
#! @output result_text: 'success' or 'failure'
#! @output return_code: 0 if success, -1 if failure
#! @result SUCCESS: element was inserted
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.xml

operation:
  name: insert_before

  inputs:
    - xml_document
    - xmlDocument:
        default: ${get("xml_document", "")}
        private: true
    - xml_document_source:
        default: xmlString
    - xmlDocumentSource:
        default: ${get("xml_document_source", "xmlString")}
        private: true
    - xpath_element_query
    - xPathElementQuery:
        default: ${get("xpath_element_query", "")}
        private: true
    - xml_element
    - xmlElement:
        default: ${get("xml_element", "")}
        private: true
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "false")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:score-xml:0.0.3'
    class_name: io.cloudslang.content.xml.actions.InsertBefore
    method_name: execute

  outputs:
    - result_xml: ${resultXML}
    - return_result: ${returnResult}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
