*** Settings ***
Library    SeleniumLibrary
Library    ExcelLibrary
Resource   ../Mentor Assessment/keyword.robot

*** Test Cases ***
TC: Mentor Assessment
    Open Website And Login
    Open Excel Document    ${data}    ${sheet}
    Go To Assessment Page

    FOR    ${i}    IN RANGE    2    ${rows}+1
        ${run_flag}=    Read Excel Cell    ${i}    2
        Run Keyword If    '${run_flag}' != 'y'    Continue For Loop
        Log To Console    Running test for row ${i}
        Reset Mentor Answer Table
        do Assessment    ${i}
    END

    Save Excel Document    ${data}
    Close Current Excel Document
    Close Browser
