Attribute VB_Name = "modDatabaseTest"

Option Explicit

Public Sub Test_ADODB()
    Dim cn As Object
    on Error GoTo GestionErreur

    'Création de l'objet ADODB.Connection
    Set cn = CreateObject("ADODB.Connection")

    MsgBox "Object ADODB créé avec succès !",vbInformation, "Sales Reporting Manager"

FindProcedure:
    'Libération de l'objet
    Set cn = Nothing

    Exit Sub

GestionErreur:
    MsgBox "Erreur :" & Err.Description, vbCritical

    Resume FindProcedure

End Sub