DROP TABLE IF EXISTS [Bases];--
CREATE TABLE [Bases] (
  [ID] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  [BaseName] VARCHAR(64) NOT NULL UNIQUE COLLATE SYSTEM_NOCASE,
  [RootFolder] VARCHAR(128) NOT NULL COLLATE SYSTEM_NOCASE,
  [DBFileName] VARCHAR(128) NOT NULL COLLATE SYSTEM_NOCASE,
  [Notes] VARCHAR(255) COLLATE SYSTEM_NOCASE,
  [CreationDate] DATETIME NOT NULL,
  [Version] INTEGER,
  [Code] INTEGER,
  [AllowDelete] BOOLEAN NOT NULL,
  [Settings] BLOB,
  [Icon] BLOB,
  [URL] VARCHAR(255) COLLATE SYSTEM_NOCASE,
  [LibUser] VARCHAR(50) COLLATE SYSTEM_NOCASE,
  [LibPassword] VARCHAR(50) COLLATE SYSTEM_NOCASE,
  [ConnectionScript] BLOB
);--

DROP TABLE IF EXISTS [Groups];--
CREATE TABLE [Groups] (
  [GroupID] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  [GroupName] VARCHAR(255) NOT NULL UNIQUE COLLATE SYSTEM_NOCASE,
  [AllowDelete] BOOLEAN NOT NULL,
  [Notes] BLOB,
  [Icon] BLOB
);--

DROP TABLE IF EXISTS [Books];--
CREATE TABLE [Books] (
  [BookID] INTEGER NOT NULL,
  [DatabaseID] INTEGER NOT NULL,
  [LibID] INTEGER NOT NULL,
  [Title] VARCHAR(150) COLLATE SYSTEM_NOCASE,
  [SeriesID] INTEGER,
  [SeqNumber] INTEGER,
  [UpdateDate] DATETIME NOT NULL,
  [LibRate] INTEGER NOT NULL,
  [Lang] VARCHAR(2) COLLATE SYSTEM_NOCASE,
  [Folder] VARCHAR(255) COLLATE SYSTEM_NOCASE,
  [FileName] VARCHAR(255) NOT NULL COLLATE SYSTEM_NOCASE,
  [InsideNo] INTEGER NOT NULL,
  [Ext] VARCHAR(10) COLLATE SYSTEM_NOCASE,
  [BookSize] INTEGER,
  [Code] INTEGER NOT NULL,
  [IsLocal] BOOLEAN NOT NULL,
  [IsDeleted] BOOLEAN NOT NULL,
  [KeyWords] VARCHAR(255) COLLATE SYSTEM_NOCASE,
  [Rate] INTEGER NOT NULL,
  [Progress] INTEGER NOT NULL,
  [Annotation] BLOB,
  [Review] BLOB,
  [ExtraInfo] BLOB,
  PRIMARY KEY ([BookID], [DatabaseID])
);--
CREATE INDEX [IXBooks_FileName] ON [Books] ([FileName]);--

CREATE TABLE [BookGroups] (
  [BookID] INTEGER NOT NULL,
  [DatabaseID] INTEGER NOT NULL,
  [GroupID] INTEGER NOT NULL,
  PRIMARY KEY ([GroupID], [BookID], [DatabaseID])
);--
CREATE INDEX [IXBookGroups_BookID_DatabaseID] ON [BookGroups] ([DatabaseID] ASC, [BookID] ASC);--

