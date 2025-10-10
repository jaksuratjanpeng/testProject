*** Settings ***
Library    SeleniumLibrary
Library    String
Library    ExcelLibrary
Resource   ../Mentor Assessment/variable.robot
Library    DatabaseLibrary
Library    Collections

*** Keywords ***
Open Website And Login
    Open Browser    ${url}    ${browser}    
    Maximize Browser Window
    Click Element    //button[contains(text(),'พี่เลี้ยง')]
    Input Text    //div[@class='mentor-form-container']//input[@placeholder=' อีเมล ']    ${email}
    Input Password    //input[@id='pwdM']    ${password} 
    Click Button    //button[@class='login-mentor-button']
    Sleep    2s
Go To Assessment Page
    Click Element    //a[contains(text(),'ประเมินให้คะแนนการฝึกสหกิจศึกษา')]
*** Keywords ***
Reset Mentor Answer Table
    Connect To Database    pymysql    ${DBNAME}    ${DBUSER}    ${DBPASS}    ${DBHOST}    ${DBPORT}
    Execute Sql String    TRUNCATE mentoranswer;
    Disconnect From Database
do Assessment
    [Arguments]    ${i}
    Click Element    //a[@class='btn btn-success']
    ${no1}    Read Excel Cell    ${i}    3
    ${no2}    Read Excel Cell    ${i}    4
    ${no3}    Read Excel Cell    ${i}    5
    ${no4}    Read Excel Cell    ${i}    6
    ${no5}    Read Excel Cell    ${i}    7
    ${no6}    Read Excel Cell    ${i}    8
    ${no7}    Read Excel Cell    ${i}    9
    ${no8}    Read Excel Cell    ${i}    10
    ${no9}    Read Excel Cell    ${i}    11
    ${no10}    Read Excel Cell    ${i}    12
    ${no11}    Read Excel Cell    ${i}    13
    ${no12}    Read Excel Cell    ${i}    14
    ${no13}    Read Excel Cell    ${i}    15
    ${no14}    Read Excel Cell    ${i}    16
    ${no15}    Read Excel Cell    ${i}    17
    ${no16}    Read Excel Cell    ${i}    18

    ${expected_result}    Read Excel Cell    ${i}    19

    Input Text    //input[@name='questions[1].answer']   ${no1}
    Input Text    //input[@name='questions[2].answer']   ${no2}
    Input Text    //input[@name='questions[3].answer']   ${no3}
    Input Text    //input[@name='questions[4].answer']    ${no4}
    Input Text    //input[@name='questions[5].answer']   ${no5}
    Input Text    //input[@name='questions[6].answer']    ${no6}
    Input Text    //input[@name='questions[7].answer']    ${no7}
    Input Text    //input[@name='questions[8].answer']    ${no8}
    Input Text    //input[@name='questions[9].answer']    ${no9}
    Input Text    //input[@name='questions[10].answer']    ${no10}
    Input Text    //input[@name='questions[11].answer']    ${no11}
    Input Text    //textarea[@name='questions[12].answer']    ${no12}
    Input Text    //textarea[@name='questions[13].answer']   ${no13}
    Input Text    //textarea[@name='questions[14].answer']   ${no14}
     
    ${no15}=    Read Excel Cell    ${i}    16
    ${no15}=    Set Variable If    '${no15}'=='None'    ""    ${no15}
    ${no15}=    Strip String    ${no15}
    
    IF    '${no15}' == 'ใช่'
        Click Element    //input[@value='ใช่']
    ELSE
        Click Element    //input[@value='ไม่ใช่']
    END

    Input Text    //textarea[@name='questions[16].answer']   ${no16}

    Click Button    //button[contains(text(),'บันทึก')]

    ${success_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    //div[@class='alert success']    3s
    ${error_elements}=    Get WebElements    //input[contains(@name,'questions') and contains(@name,'.answer')]

    IF    ${success_visible}
        ${Actual_Result}=    Get Text    //div[@class='alert success']
    ELSE IF    ${error_elements}
        ${messages}=    Create List
        FOR    ${el}    IN    @{error_elements}
        ${msg}=    Execute Javascript    arguments[0].reportValidity(); return arguments[0].validationMessage;    ARGUMENTS    ${el}
        Run Keyword If    '${msg}' != ''    Append To List    ${messages}    ${msg}
        END
        ${Actual_Result}=    Catenate    SEPARATOR=\n    @{messages}
        Click Element    //a[contains(text(),'ยกเลิก')]
    ELSE
        ${Actual_Result}=    Set Variable    ไม่มีข้อความตอบกลับ
    END

    
    # ลบเครื่องหมาย ×
    ${Actual_Result}=    Replace String    ${Actual_Result}    ×    ${EMPTY}

    # ลบ newline (\n) ออก
    ${Actual_Result}=    Replace String    ${Actual_Result}    \n    ${SPACE}
    
    ${expected_result}=    Strip String    ${expected_result}
    ${Actual_Result}=      Strip String    ${Actual_Result}

    Log To Console    => Expected: ${Expected_Result}
    Log To Console    => Actual: ${Actual_Result}

    ${flag}=    Run Keyword And Return Status    Should Be Equal As Strings    ${Actual_Result}    ${expected_result}    

    IF    ${flag}
        Write Excel Cell    ${i}    21    pass
        Write Excel Cell    ${i}    20    ${Actual_Result}
    ELSE
        Write Excel Cell    ${i}    21    fail
        Write Excel Cell    ${i}    20    ${Actual_Result}
    END

    

