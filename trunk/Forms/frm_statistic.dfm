object frmStat: TfrmStat
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
  ClientHeight = 165
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object RzBitBtn1: TButton
    Left = 116
    Top = 135
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object RzPanel1: TRzPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 302
    Height = 70
    Align = alTop
    BorderOuter = fsFlatRounded
    TabOrder = 1
    object lblName: TRzLabel
      Left = 94
      Top = 8
      Width = 45
      Height = 13
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDate: TRzLabel
      Left = 94
      Top = 27
      Width = 45
      Height = 13
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RzLabel5: TRzLabel
      Left = 8
      Top = 27
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
    end
    object RzLabel1: TRzLabel
      Left = 29
      Top = 8
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1083#1083#1077#1082#1094#1080#1103':'
    end
    object RzLabel6: TRzLabel
      Left = 49
      Top = 46
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1077#1088#1089#1080#1103':'
    end
    object lblVer: TRzLabel
      Left = 94
      Top = 46
      Width = 45
      Height = 13
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object RzPanel2: TRzPanel
    AlignWithMargins = True
    Left = 3
    Top = 79
    Width = 302
    Height = 50
    Align = alTop
    BorderOuter = fsFlatRounded
    TabOrder = 2
    object RzLabel2: TRzLabel
      Left = 8
      Top = 20
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1040#1074#1090#1086#1088#1086#1074':'
    end
    object lblAuthors: TRzLabel
      Left = 61
      Top = 20
      Width = 45
      Height = 13
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RzLabel3: TRzLabel
      Left = 124
      Top = 20
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1085#1080#1075':'
    end
    object lblBooks: TRzLabel
      Left = 158
      Top = 20
      Width = 45
      Height = 13
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RzLabel4: TRzLabel
      Left = 209
      Top = 20
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1077#1088#1080#1081':'
    end
    object lblSeries: TRzLabel
      Left = 248
      Top = 20
      Width = 45
      Height = 13
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
