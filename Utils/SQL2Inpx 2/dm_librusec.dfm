object Lib: TLib
  OldCreateOrder = False
  Height = 472
  Width = 564
  object Connection: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver150.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=15.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver150.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=15.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'VendorLib=LIBMYSQL.dll'
      'HostName=localhost'
      'Database=librusec'
      'User_Name=libpass'
      'Password=pass'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'BlobSize=-1'
      'ErrorResourceFile='
      'ServerCharSet=utf8')
    VendorLib = 'LIBMYSQL.dll'
    AfterConnect = ConnectionAfterConnect
    Connected = True
    Left = 56
    Top = 32
  end
  object dspLibBook: TDataSetProvider
    DataSet = Book
    Constraints = False
    Exported = False
    Options = [poCascadeUpdates, poAutoRefresh]
    Left = 144
    Top = 112
  end
  object cdsLibBook: TClientDataSet
    Active = True
    Aggregates = <>
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspLibBook'
    AfterScroll = cdsLibBookAfterScroll
    Left = 232
    Top = 112
  end
  object dsLibBook: TDataSource
    DataSet = cdsLibBook
    Left = 312
    Top = 112
  end
  object Book: TSQLQuery
    Active = True
    MaxBlobSize = -1
    ParamCheck = False
    Params = <>
    SQL.Strings = (
      
        'SELECT B.BookId, B.Title, B.FileSize, B.FileType, B.Deleted, B.T' +
        'ime, B.Lang, B.KeyWords FROM libbook B limit 25')
    SQLConnection = Connection
    Left = 56
    Top = 112
    object BookBookId: TIntegerField
      FieldName = 'BookId'
      Required = True
    end
    object BookTitle: TWideStringField
      FieldName = 'Title'
      Required = True
      Size = 762
    end
    object BookFileSize: TIntegerField
      FieldName = 'FileSize'
      Required = True
    end
    object BookFileType: TWideStringField
      FieldName = 'FileType'
      Required = True
      FixedChar = True
      Size = 12
    end
    object BookDeleted: TWideStringField
      FieldName = 'Deleted'
      Required = True
      FixedChar = True
      Size = 3
    end
    object BookTime: TSQLTimeStampField
      FieldName = 'Time'
    end
    object BookLang: TWideStringField
      FieldName = 'Lang'
      Required = True
      FixedChar = True
      Size = 6
    end
    object BookKeyWords: TWideStringField
      FieldName = 'KeyWords'
      Required = True
      Size = 765
    end
  end
  object Genre: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftWideString
        Name = 'GenreCode'
        ParamType = ptInput
        Value = 252421
      end>
    SQL.Strings = (
      
        'SELECT G.GenreCode  FROM libgenrelist G, libgenre GL WHERE GL.Bo' +
        'okId = 1')
    SQLConnection = Connection
    Left = 56
    Top = 192
    object GenreGenreCode: TWideStringField
      FieldName = 'GenreCode'
      Size = 135
    end
  end
  object dspGenre: TDataSetProvider
    DataSet = Genre
    Constraints = False
    ResolveToDataSet = True
    Left = 136
    Top = 192
  end
  object cdsGenre: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'GenreCode'
    Params = <>
    ProviderName = 'dspGenre'
    Left = 232
    Top = 192
  end
  object dsGenre: TDataSource
    DataSet = cdsGenre
    Left = 312
    Top = 192
  end
  object Avtor: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'select an.LastName, an.FirstName, an.MiddleName '
      
        'from (libavtor ba left outer join libavtoraliase aa on aa.badid ' +
        '= ba.avtorid) '
      
        'join libavtorname an on an.avtorid = COALESCE(aa.goodid, ba.avto' +
        'rid) WHERE  ba.bookid=2250')
    SQLConnection = Connection
    Left = 56
    Top = 264
    object AvtorLastName: TWideStringField
      FieldName = 'LastName'
      Required = True
      Size = 297
    end
    object AvtorFirstName: TWideStringField
      FieldName = 'FirstName'
      Required = True
      Size = 297
    end
    object AvtorMiddleName: TWideStringField
      FieldName = 'MiddleName'
      Required = True
      Size = 297
    end
  end
  object dspAvtor: TDataSetProvider
    DataSet = Avtor
    ResolveToDataSet = True
    Options = [poAutoRefresh, poUseQuoteChar]
    Left = 136
    Top = 256
  end
  object cdsAvtor: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAvtor'
    Left = 232
    Top = 256
  end
  object dsAvtor: TDataSource
    DataSet = cdsAvtor
    Left = 312
    Top = 256
  end
  object Series: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      
        'SELECT S.SeqName, SL.SeqNumb FROM libseqname S, libseq SL WHERE ' +
        'SL.BookId = 1')
    SQLConnection = Connection
    Left = 56
    Top = 320
    object SeriesSeqName: TWideStringField
      FieldName = 'SeqName'
      Required = True
      Size = 762
    end
    object SeriesSeqNumb: TIntegerField
      FieldName = 'SeqNumb'
    end
  end
  object dspSeries: TDataSetProvider
    DataSet = Series
    Constraints = False
    ResolveToDataSet = True
    Left = 136
    Top = 320
  end
  object cdsSeries: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspSeries'
    Left = 232
    Top = 320
  end
  object dsSeries: TDataSource
    DataSet = cdsSeries
    Left = 312
    Top = 320
  end
  object Query: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = Connection
    Left = 144
    Top = 32
  end
end
