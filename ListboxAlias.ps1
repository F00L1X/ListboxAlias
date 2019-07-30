<#
#### requires ps-version 3.0 ####
<#
.SYNOPSIS
< WPF / GUI App that provides you with listbox items, that when selected and confirmed outputs a string to replace a line of text in a file of you define.>
.DESCRIPTION
<WPF / GUI App that provides you with listbox items, that when selected and confirmed outputs a string to replace a line of text in a file of you define.>

.INPUTS
NONE
.OUTPUTS
Outputs text and\or alias to replace a line of text in a file. (Good for when you need to push an app to customers that need different entries in configuration-files that doesn't )
.NOTES
   Version:        0.1
   Author:         Remi Andrè Lilleskare
   Creation Date:  Tuesday, July 30th 2019, 12:38:49 pm
   File: ListBoxAlias.ps1
HISTORY:
Date      	          By	Comments
----------	          ---	----------------------------------------------------------

.LINK
   

.COMPONENT
 Required Modules: 

.LICENSE
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the Software), to deal
in the Software without restriction, including without limitation the rights
to use copy, modify, merge, publish, distribute sublicense and /or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 
.EXAMPLE
<Example goes here. Repeat this attribute for more than one example>
#

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#---------------------------------------------------------[Variables]--------------------------------------------------------
#Log File Info
#$sLogPath = 
#$sLogName = script_name.log
#$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#---------------------------------------------------------[Modules]--------------------------------------------------------

#---------------------------------------------------------[Functions]--------------------------------------------------------
#>






# Find logged on user
$Loggedon = Get-WmiObject -ComputerName $env:COMPUTERNAME -Class Win32_Computersystem | Select-Object UserName

# Split domain and user
$Domain,$User = $Loggedon.Username.split('\',2)

{
  # get error record
  [Management.Automation.ErrorRecord]$e = $_

  # retrieve information about runtime error
  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Script    = $e.InvocationInfo.ScriptName
    Line      = $e.InvocationInfo.ScriptLineNumber
    Column    = $e.InvocationInfo.OffsetInLine
  }
  
  # output information. Post-process collected info, and log info (optional)
  $info
}

{
  # get error record
  [Management.Automation.ErrorRecord]$e = $_

  # retrieve information about runtime error
  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Script    = $e.InvocationInfo.ScriptName
    Line      = $e.InvocationInfo.ScriptLineNumber
    Column    = $e.InvocationInfo.OffsetInLine
  }
  
  # output information. Post-process collected info, and log info (optional)
  $info#>
}

# Creates WindowsForm / GUI for the application
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Heading
$form = New-Object -TypeName System.Windows.Forms.Form
$form.Text = 'Your form text'
$form.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (400, 600)
$form.StartPosition = 'CenterScreen'

# OK-Button
$OKButton = New-Object -TypeName System.Windows.Forms.Button
$OKButton.Location = New-Object -TypeName System.Drawing.Point -ArgumentList (170, 485)
$OKButton.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (100, 50)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

# Cancel-Button
$CancelButton = New-Object -TypeName System.Windows.Forms.Button
$CancelButton.Location = New-Object -TypeName System.Drawing.Point -ArgumentList (270, 485)
$CancelButton.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (100, 50)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

# Text-label
$label = New-Object -TypeName System.Windows.Forms.Label
$label.Location = New-Object -TypeName System.Drawing.Point -ArgumentList (10, 20)
$label.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (280, 20)
$label.Text = 'Your label text:'
$form.Controls.Add($label)

# List-box
$listBox = New-Object -TypeName System.Windows.Forms.ListBox
$listBox.Location = New-Object -TypeName System.Drawing.Point -ArgumentList (10, 40)
$listBox.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (360, 20)
$listBox.Height = 400


<# Hashtable with the different "Aliases" Here you can define the alias of each entry in the listbox-menu. The name of the listbox object on the left. The alias on the right #>
$Script:Hash = @{
    'ORIGINAL NAME1' = 'Alias-out1'
    'ORIGINAL NAME2' = 'Alias-out2'
    'ORIGINAL NAME3' = 'Alias-out3'
}

# These are the actual listbox-items. Add as many of these as you have listbox-aliases above. Make sure that the name of the listbox-item matches what you want the alias to be.
$null =  $listBox.Items.Add('ORIGINAL NAME1')
$null =  $listBox.Items.Add('ORIGINAL NAME2')
$null =  $listBox.Items.Add('ORIGINAL NAME3')

# Magic to make the selected listbox item activate the change in the file you want to add an entry to.

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [Windows.Forms.DialogResult]::OK)
{
  $Script:Hash = $Script:Hash[$listBox.SelectedItem]
    
}


# File to change
$file = "C:\Users\$User\test.txt"

# Get file content and store it into $content variable
$content = Get-Content -Path $file

# Changes text\string on line 33 and 53 of your chosen file. This can ofcourse be tweaked to suit your needs.
$content[32] = 'Content you want to change1'+$Script:Hash
$content[52] = 'Content you want to change2'+$Script:Hash


# Set the new content
$content | Set-Content -Path $file

$form.Controls|%{$_.Text}