; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing %ProgramData%\ezRead\AdobePlugin\03_Basic.ahk
; 
; Ctrls used to express keystrokes
; ================================
; Ctrl = ^
; Alt  = !
; Shift = +
; F?? = F12
; Enter = {Enter}
; Page Up = {PgUp}
; Page Down = {PgDn}
; svar := Chr(55)  // for characters from ASCII number
; Send %svar%

#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input               ; Reset precommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2         ; works with partial title information

;---------------------------------------
; Auto-Hotkey admin commands
; Once associated the .ahk file type [edit] with UltraEdit
;--------------------------------------
; Edit the secript ... replace notepad.exe by your prefered ASCII editor
;--------------------------------------
; Ctrl-F12 | edit the secript
;--------------------------------------
^F12::
run ,notepad.exe %A_ScriptFullPath%,,
return

;--------------------------------------
; Ctrl+Shift F12 | Reload script after editing
;--------------------------------------
^+F12::
reload
return

;--------------------------------------
; Ctrl-Alt F12 | Show help file
;--------------------------------------
^!F12::
SplitPath, A_AhkPath, AhkFile, AhkDir
run "%AhkDir%\AutoHotkey.chm"
return

;--------------------------------------
; Shift-Alt F12 | Open the PID box to catch program specific information
;--------------------------------------
+!F12::
SplitPath, A_AhkPath, AhkFile, AhkDir
run "%AhkDir%\AU3_Spy.exe"
return

;---------------------------------------
; Instant launch of a document using F12 technology
;---------------------------------------
^+!F12::
AutoTrim, Off
; save clipboard
ClipText := Clipboard
InputBox, DocuTag, Enter document tag, Example: ezRead#3.3 ,, 200, 140
if ErrorLevel
  return

BracketTag = [%DocuTag%]
; MsgBox BracketTag = %BracketTag%

RegRead, ProjDoc, HKEY_CURRENT_USER, Environment, ProjDoc

StbStr  := ChangeBookMark(BracketTag)
PosExt  := Instr(StbStr, "_")
if (PosExt = 0)
  PosExt := StrLen(StbStr) + 1
PathExt := SubStr(StbStr, 1, PosExt-1)
StbPath = %ProjDoc%\dev\ref\stb\%PathExt%\%StbStr%.stb
; MsgBox %StbPath%

Clipboard = %ClipText%
IfExist %StbPath%
{
  Run, %StbPath%
  Clipboard =
  ClipStr  := RegExReplace(StbStr, "\\", "/", 0, -1, 1)
  Clipboard = %StbPath%
}
AutoTrim, On
return


;======================================
; Functions
;======================================
;--------------------------------------
; @func String | ChangeBookMark | changes the syntax of a [Bookmark#Chapter] entry by replacing characters
; @parm String | ClipText | Entry to be modified e.g. "see in [ISO4#5.4.1] to learn more"
; @desc
; <space> is removed
; '.' to 'v' if previous char was number, else '.' to 'p'
; '_' to 'u'
; '-' to 'm'
; etc.
; [GSM 11.5 Std#4.3] becomes GSM11v5Std#Ch4p3.stb, ignoring blanks and respect version info
; [ISO4#5.4.1]  becomes ISO4_Ch5p4p1.stb
; [ISO4#LogChn] becomes ISO_LogChn.stb. The "Ch" prefix is not added because there is no number behind the #
; @output The function returns the modified string
;--------------------------------------
ChangeBookMark(ClipText)
{
; remove "["
  LeftBrk := InStr(ClipText, "[")
  StringTrimLeft, StRi, ClipText, LeftBrk
; MsgBox StRi = %StRi%

; remove "]"
  RightBrk := InStr(StRi, "]")
  CutRight := StrLen(StRi) - RightBrk + 1
  StringTrimRight, StCut, StRi, CutRight
; MsgBox RightBrk = %StCut%

; We allow link text placed like [ISO Standard::ISO4#5.3] with :: as separator
; remove "::"
  LeftBrk := InStr(StCut, "::")
  if (LeftBrk > 0)
    StringTrimLeft, StLe, StCut, LeftBrk + 1
  else
    StLe = %StCut%
    
; MsgBox StLe = %StLe%

; replace Prefix dot by version 'v' or point 'p' if part of a text with no numbers
  DotStr  := RegExReplace(StLe, "_", "u", 0, -1, 1)
  ChStr   := RegExReplace(DotStr, "(?<=[0-9])\.(?=.*#)","v")
  DashStr := RegExReplace(ChStr, "(?<![0-9])\.(?=.*#)","p")

; replace minus - only in the chapter part
; "(?=.*#)-", "m"  replaces in the prefix  part
; "(?!.*#)-", "m"  replaces in the chapter part
  IfInString DashStr , #
  {
    StLe  := RegExReplace(DashStr, "(?!.*#)-", "m")
; replace chapter delimiter #
    ChStr := RegExReplace(StLe, "#(?=[0-9])","_Ch")
    StLe  := RegExReplace(ChStr, "#(?![0-9])","_")
  }
  else
  {
    StLe = %DashStr%
  }

; replace chapter delimiter #

; replace general space, dot, dash
  ChStr   := RegExReplace(StLe, " ", "", 0, -1, 1)
  DotStr  := RegExReplace(ChStr, "\.", "p", 0, -1, 1)
  ColonStr := RegExReplace(DotStr, ":", "", 0, -1, 1)
  StbStr  = %ColonStr%
; MsgBox StbStr = %StbStr%
  return %StbStr%
}

;========================================
; Acrobat
; ahk_class 
;========================================
#IfWinActive ahk_class AcrobatSDIWindow
;---------------------------
; Shift PgUp - goto previous document in Acrobat
;---------------------------
+PgUp::
Send !xp
return

;---------------------------
; Shift PgUp - goto previous document in Acrobat
;---------------------------
+PgDn::
Send !xc
return
;--------------------------------------
#IfWinActive
;--------------------------------------

;--------------------------------------
; Clipboard commands - ezRead
;--------------------------------------

;--------------------------------------
; Ctrl-Shift K | return full path into to stub associated after pressing F12
;                very helpful when creating hyperlinks in MicroSoft Office
;                First do an instant link (F12) then Create Hyperlink and insert Ctrl-Shift-K
; This function does not send the data but puts it to the clipboard, see the next function to send
;--------------------------------------
; #IfWinActive ahk_class PPTFrameClass
^+k::
AutoTrim, Off
Clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived
Send ^c
ClipWait, 1
RegRead, ProjDoc, HKEY_CURRENT_USER, Environment, ProjDoc
ClipText := Clipboard
StbStr  := ChangeBookmark(ClipText)
PosExt  := Instr(StbStr, "_")
PathExt := SubStr(StbStr, 1, PosExt-1)
;MsgBox PathExt = %PathExt% PosExt = %PosExt%
StbPath = %ProjDoc%\dev\ref\stb\%PathExt%\%StbStr%.stb
IfExist %StbPath%
  Clipboard =
  Clipboard = %StbPath%
AutoTrim, On
return
; #IfWinActive


;=================================
; Office 2010 - Word
;=================================
;--------------------------------------
; Ctrl-Shift K | return full path into to stub associated after pressing F12
;                very helpful when creating hyperlinks in MicroSoft Office
;                First do an instant link (F12) then Create Hyperlink and insert Ctrl-Shift-K
;
; This function sends the actual path
;--------------------------------------
#IfWinActive Insert Hyperlink
^+k::
ClipText := Clipboard
RegRead, ProjDoc, HKEY_CURRENT_USER, Environment, ProjDoc
PosExt  := Instr(ClipText, "_")
PathExt := SubStr(ClipText, 1, PosExt-1)
;MsgBox PathExt = %PathExt% PosExt = %PosExt%
StbPath = %ProjDoc%\dev\ref\stb\%PathExt%\

IfExist %StbPath%
{
  Send %StbPath%%ClipText%.stb
; Clipboard =
; Clipboard = %StbPath%
}
return
;------------------------------------
; END Office 2010
;------------------------------------
#IfWinActive


;========================================
; Global Settings
;========================================

;----------------------------------------------------
; Send Date as YYYYMMDD, leaving the field 3 empty delivers current date
;----------------------------------------------------
^+d::
FormatTime, DateString, , yyyyMMdd
Send %DateString%
;MsgBox The current date is %DateString%.
return

;----------------------------------------------------
; Instant Hyperlink to Stub (new version with /stb/<name> directories
; [ISO4#5.1]
; [ezRead]
;----------------------------------------------------
F12::
AutoTrim, Off
Clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived
Send ^c
ClipWait, 1
RegRead, ProjDoc, HKEY_CURRENT_USER, Environment, ProjDoc

;Clipboard = %A_Space%=[Dght6#6] bullshit"
ClipText := Clipboard

StbStr  := ChangeBookMark(ClipText)

;MsgBox StbPath = %StbStr%

PosExt  := Instr(StbStr, "_")
if (PosExt = 0)
  PosExt := StrLen(StbStr) + 1
PathExt := SubStr(StbStr, 1, PosExt-1)
; MsgBox PathExt = %PathExt% PosExt = %PosExt%
StbPath = %ProjDoc%\dev\ref\stb\%PathExt%\%StbStr%.stb
; MsgBox StbPath = %StbPath%
Clipboard = %ClipText%
IfExist %StbPath%
{
  Run, %StbPath%
  Clipboard =
  ClipStr  := RegExReplace(StbStr, "\\", "/", 0, -1, 1)
  Clipboard = %ClipStr%
  Clipboard = %StbPath%
}
AutoTrim, On
return

;----------------------------------------------------
; Ctrl+Shift+Alt Space | convert Backslash to Slash
;----------------------------------------------------
^+!Space::
ClipText := Clipboard
StringReplace, NoSpaces, ClipText,%A_Space%,,A
Clipboard =
Clipboard = %NoSpaces%
return

;----------------------------------------------------
; Ctrl / | Convert Backslash to Slash
;----------------------------------------------------
^/::
ClipText := Clipboard
SlashStr  := RegExReplace(ClipText, "\\", "/")
Clipboard =
Clipboard = %SlashStr%
return

;---------------------------------------
; Ctrl+Insert | Remove formatting information from Clipboard
;---------------------------------------
^+Ins::
Send ^C
Run, ClipText.exe,,Hide
return

;---------------------------------------
; Ctrl+Del | Remove formatting information from Clipboard and join lines
;            The function is very practical when copying text from PDF files
;---------------------------------------
^+Del::
Send ^C
Run, ClipJoin.exe,,Hide
return

