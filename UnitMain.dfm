object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Mine Server'
  ClientHeight = 169
  ClientWidth = 408
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 15
  object ButtonAct: TButton
    Left = 192
    Top = 64
    Width = 129
    Height = 25
    Caption = 'Start MineServer'
    TabOrder = 0
    OnClick = ButtonActClick
  end
  object ncServerSource1: TncServerSource
    EncryptionKey = 'SetEncryptionKey'
    OnHandleCommand = ncServerSource1HandleCommand
    Left = 48
    Top = 48
  end
end
