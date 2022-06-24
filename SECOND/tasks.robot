*** Settings ***
Documentation    Order robots from website
Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.HTTP
Library    RPA.Excel.Files
Library    RPA.Tables
Library    RPA.PDF
Library    RPA.Archive
Library    RPA.JavaAccessBridge
Library    OperatingSystem
*** Variables ***
${folderpath}=    C:\\Users\\CANAVE\\Documents\\ROBOCORP\\SECOND\\Screenshots

*** Tasks ***
Order robots from website
    Download and save File    
    Open Order Website
    #Create Directory    C:\\Users\\CANAVE\\Documents\\ROBOCORP\\SECOND\\Screenshots
    ${orders}=    Read table from CSV    orders.csv    header=TRUE
      FOR    ${order}    IN    @{orders}
        Close pop up
        Fill form    ${order}
        ${screenshot}=    Preview and Screenshot    ${order}
        Wait Until Keyword Succeeds    30    5 s    Order
        ${pdf}=    Save receipts    ${order}
        Unite Screenshot and receipt    ${order}
        Delete Screenshots    ${order}
        Order another robot
    END
    Archive Folder With Zip    ${folderpath}    Screenshots.zip    TRUE  
*** Keywords ***
Download and save file  
#Se descarga el documento y se salva dentro de una carpeta
    Download    https://robotsparebinindustries.com/orders.csv    Downloaded_orders    overwrite=TRUE
Open Order Website
#Se abre la pagina web
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order    maximized=True
Close pop up
#Se cerrará el pop up de inicio de página
    Click Button     OK
Fill form
#Se llenará el formulario mediante el csv file ya antes presentado
    [Arguments]    ${order}
    Select From List By Value    head  ${order}[Head] 
    Select Radio Button    body    ${order}[Body]
    Input Text    //input[@placeholder='Enter the part number for the legs']    ${order}[Legs]
    Input Text    address    ${order}[Address]
Preview and Screenshot
#Se hará la vista previa al robot y mas aparte se tomará el screenshot y se dirigirá a un file 
    [Arguments]    ${order}
    Click Button    preview
    Wait Until Element Is Visible    id:robot-preview-image
    Screenshot    id:robot-preview-image    ${folderpath}${/}${order}[Order number].png
Order
#Clickear el botón de ordenar para ordenar el botón
    Click Button    order
    Wait Until Element Is Visible    id:receipt
Save receipts
#Guardar los recibos
    [Arguments]    ${order}
    ${order_results}=     Get Element Attribute    id:receipt    outerHTML   
    Html To Pdf    ${order_results}    ${folderpath}${/}${order}[Order number].pdf  
Unite Screenshot and receipt
#Combinar el screenshot y el recibo en un mismo documento
    [Arguments]    ${order}
    Open Pdf     ${folderpath}${/}${order}[Order number].pdf  
    Add Watermark Image To Pdf     ${folderpath}${/}${order}[Order number].png    ${folderpath}${/}${order}[Order number].pdf    
Delete Screenshots
    [Arguments]    ${order}    
    Remove File    ${folderpath}${/}${order}[Order number].png
Order another robot 
#Pulsar el botón order another para ordenar otro robot
    Click Button   order-another
    #aaaaaaaaa prri tambien borraste las imagenes 10/10