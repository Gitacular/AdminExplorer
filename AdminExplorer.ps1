# Konsole ausblenden
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

public static void Hide()
{
    var handle = GetConsoleWindow();
    ShowWindow(handle, 0); // 0 = SW_HIDE
}

public static void Show()
{
    var handle = GetConsoleWindow();
    ShowWindow(handle, 5); // 5 = SW_SHOW
}'

# Verstecken Sie das Konsolenfenster
[Console.Window]::Hide()

# Prüfen, ob das Skript bereits mit Administratorrechten läuft
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Skript mit Administratorrechten neu starten
    Start-Process PowerShell -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Öffnen - Dialog starten
Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.ShowDialog() | Out-Null
