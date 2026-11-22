Attribute VB_Name = "modDatabaseTest"

Option Explicit

Public Sub Test_ADODB()
    
    Dim cn As Object
    Dim connectionString As String
    Dim dbPassword As String

    on Error GoTo GestionErreur

    'Création de l'objet ADODB.Connection
    Set cn = CreateObject("ADODB.Connection")

    'Saisie le mot de passe PostgeSQL
    dbPassword = InputBox( _
        "Saisissez le mot de passe PostgreSQL :", _
        "Connexion PostgreSQL"_
    )

    If Len(dbPassword) = 0 Then
        MsgBox "Aucun mot de passe saisi.", vbExclamation
        GoTo  FinProcedure
    End If

    'Construction de la chaîne de connexion
    connectionString = _
        "Provider=MSDASQL;" & _
        "Driver={PostgreSQL Unicode(x64)};" & _
        "Server=localhost;" & _
        "Port=5432;" & _
        "Database=sales_reporting_db;" & _
        "Uid=user_portfolio;" & _
        "Pwd=" & dbPassword & ";"

    'Ouverture de la connexion
    cn.Open connectionString

    If cn.State = 1 Then
        MsgBox "Connexion PostgreSQL établie avec succès !",
            vbInformation,
            "Sales Reporting Manager"
    End If

FinProcedure:
On Error Resume Next

    'Ferméture et libération de la connexion ADODB
    'Vérifie si l'objet ADODB existe
    If Not cn Is Nothing Then 
        'Si la connexion est ouverte
        If cn.State = 1 Then 
            cn.Close 'ferme la connexion
        End If

        Set cn = Nothing
    End If

    On Error GoTo 0
    
    Exit Sub

GestionErreur:
    MsgBox "Erreur :" & Err.Description, vbCritical

    Resume FinProcedure

End Sub