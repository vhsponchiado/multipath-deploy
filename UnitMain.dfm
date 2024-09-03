object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Deploy'
  ClientHeight = 320
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clSilver
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  Visible = True
  OnCreate = FormCreate
  TextHeight = 15
  object lblFilePath: TLabel
    Left = 24
    Top = 94
    Width = 77
    Height = 28
    Caption = 'File Path'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblConfigIni: TLabel
    Left = 24
    Top = 25
    Width = 93
    Height = 28
    Caption = 'Config INI'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtFilePath: TEdit
    Left = 24
    Top = 129
    Width = 361
    Height = 23
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnChange = edtFilePathChange
  end
  object btnSearchPath: TButton
    Left = 399
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 1
    OnClick = btnSearchPathClick
  end
  object btnTransfer: TButton
    Left = 24
    Top = 174
    Width = 75
    Height = 25
    Caption = 'Transfer'
    TabOrder = 2
    OnClick = btnTransferClick
  end
  object btnExecute: TButton
    Left = 112
    Top = 174
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 3
    OnClick = btnExecuteClick
  end
  object edtConfigPath: TEdit
    Left = 24
    Top = 59
    Width = 361
    Height = 23
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    OnChange = edtConfigPathChange
  end
  object btnSearchConfig: TButton
    Left = 399
    Top = 58
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 5
    OnClick = btnSearchConfigClick
  end
  object OpenDialog: TOpenDialog
    Left = 68
    Top = 240
  end
  object OpenDialogConfig: TOpenDialog
    Left = 189
    Top = 240
  end
end
