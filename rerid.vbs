Option Explicit

Const MarkerFileName = "IDGeneratedMarker.txt"

Function MarkerFileExists()
    Dim fso
    Set fso = CreateObject("Scripting.FileSystemObject")
    MarkerFileExists = fso.FileExists(MarkerFileName)
    Set fso = Nothing
End Function

Sub CreateMarkerFile()
    Dim fso, markerFile
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set markerFile = fso.CreateTextFile(MarkerFileName)
    markerFile.Close
    Set markerFile = Nothing
    Set fso = Nothing
End Sub

Function GetRegionFromLocale()
    Dim objShell, objReg, locale, region

    Set objShell = CreateObject("WScript.Shell")

    locale = objShell.RegRead("HKCU\Control Panel\International\LocaleName")

    If InStr(locale, "-") > 0 Then
        region = Split(locale, "-")(1)
    Else
        region = ""
    End If

    GetRegionFromLocale = region
End Function

Function GenerateRerID(purpose, platform, locationCode, region)
    Dim purposeNumber, letters, randNum1, randNum2, randNum3, randNum4
    Dim rerID

    Select Case LCase(purpose)
        Case "game"
            purposeNumber = 36
        Case "app"
            purposeNumber = 42
        Case "git project"
            purposeNumber = 98
        Case Else
            GenerateRerID = "Invalid purpose entered!"
            Exit Function
    End Select

    Select Case LCase(platform)
        Case "com"
            letters = "COM"
        Case "ntb"
            letters = "NTB"
        Case "phn"
            letters = "PHN"
        Case Else
            GenerateRerID = "Invalid platform entered!"
            Exit Function
    End Select

    If region <> "" Then
        Select Case region
            Case "US"
                randNum1 = Int((500 - 110 + 1) * Rnd + 110)
                randNum2 = Int((500 - 110 + 1) * Rnd + 110)
                randNum3 = Int((500 - 110 + 1) * Rnd + 110)
            Case "SK"
                randNum1 = Int((300 - 100 + 1) * Rnd + 100)
                randNum2 = Int((300 - 100 + 1) * Rnd + 100)
                randNum3 = Int((300 - 100 + 1) * Rnd + 100)
            Case Else
                randNum1 = Int((500 - 110 + 1) * Rnd + 110)
                randNum2 = Int((500 - 110 + 1) * Rnd + 110)
                randNum3 = Int((500 - 110 + 1) * Rnd + 110)
        End Select
    Else
        GenerateRerID = "Could not detect region."
        Exit Function
    End If
    randNum4 = Int((2479 - 1245 + 1) * Rnd + 1245)

    rerID = purposeNumber & "-" & letters & "-" & randNum1 & ":" & randNum4

    GenerateRerID = rerID
End Function

Function RandomNumber(min, max)
    RandomNumber = Int((max - min + 1) * Rnd + min)
End Function

If MarkerFileExists() Then
    MsgBox "You have already generated an ID. You can only use this script once.", vbExclamation, "RerID Generator"
Else
    Dim purpose, platform, region
    purpose = InputBox("Enter purpose (game/app/git project):", "RerID Generator")
    platform = InputBox("Enter platform (COM/NTB/PHN):", "RerID Generator")

    region = GetRegionFromLocale()

    If purpose <> "" And platform <> "" Then
        Dim locationCode
        locationCode = InputBox("Enter location code (e.g., +421 for Slovakia):", "RerID Generator")

        If locationCode <> "" Then
            Dim generatedRerID
            generatedRerID = GenerateRerID(purpose, platform, locationCode, region)

            If generatedRerID <> "Could not detect region." Then
                MsgBox "Generated RerID: " & generatedRerID, vbInformation, "RerID Generator"
        
                CreateMarkerFile()
            Else
                MsgBox "Invalid input or region detection failed.", vbExclamation, "RerID Generator"
            End If
        End If
    End If
End If
