from pathlib import Path
from datetime import datetime
from shutil import copy2

import win32com.client

#===========================================
# CONFIGURATION
#===========================================

PROJECT_ROOT = Path(__file__).resolve().parent.parent

WORKBOOK_PATH = (
    PROJECT_ROOT
    / "workbook"
    / "SalesReportingManager.xlsm"
)

MODULE_PATH = (
    PROJECT_ROOT
    / "src"
    / "modules"
    / "modDatabaseTest.bas"
)

#===========================================
# SYNCHRONUSATION VBA
#===========================================

def sync_vba():

    excel = None
    workbook = None

    # Vérification des fichiers
    if not WORKBOOK_PATH.is_file():
        raise FileNotFoundError(
            f"Classeur introuvable : {WORKBOOK_PATH}"
        )
    
    if not MODULE_PATH.is_file():
        raise FileNotFoundError(
            f"Module VBA introuvable : {MODULE_PATH}"
        )

    # Création d'une sauvegarde
    backup_dir = PROJECT_ROOT / "backups"
    backup_dir.mkdir(exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    backup_path = (
        backup_dir
        / f"SalesReportingManager_{timestamp}.xlsm"
    )
    
    copy2(WORKBOOK_PATH, backup_path)

    print(f"Sauvegarde créée : {backup_path.name}")

    try:

        # Création d'une instance Excel indépendante
        excel = win32com.client.DispatchEx(
            "Excel.Application"
        )

        excel.Visible = False
        excel.DisplayAlerts = False

        # Ouverture du classeur
        workbook = excel.Workbooks.Open(
            str(WORKBOOK_PATH)
        )

        # Accès au projet VBA
        vb_project = workbook.VBProject
        module_name = MODULE_PATH.stem

        # Recherche d'un module existant
        for component in vb_project.VBComponents:
            if component.Name == module_name:
                vb_project.VBComponents.Remove(
                    component
                )
                break
        
        # Importation du module VBA
        vb_project.VBComponents.Import(
            str(MODULE_PATH)
        )

        # Enregistrement
        workbook.Save()

        print("Synchronisation VBA réussie")

    except Exception as error:
        print(f"Erreur : {error}")
    finally:
        if workbook is not None:
            workbook.Close(SaveChanges=False)

        if excel is not None:
            excel.Quit()

if __name__ == "__main__":
    sync_vba()