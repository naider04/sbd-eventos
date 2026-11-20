USE [master];
GO

CREATE DATABASE [NaiderFiestasEventos];
GO

USE [NaiderFiestasEventos];
GO

CREATE TABLE [dbo].[TipoEvento] (
    [id_tipo_evento] int IDENTITY(1,1) NOT NULL,
    [nombre] nvarchar(60) NOT NULL,
    [descripcion] nvarchar(255) NULL,
    CONSTRAINT [PK_TipoEvento] PRIMARY KEY CLUSTERED ([id_tipo_evento] ASC),
    CONSTRAINT [UQ_TipoEvento_nombre] UNIQUE ([nombre] ASC)
);
GO

CREATE TABLE [dbo].[Cliente] (
    [id_cliente] int IDENTITY(1,1) NOT NULL,
    [cedula] varchar(10) NOT NULL,
    [nombres] nvarchar(60) NOT NULL,
    [apellidos] nvarchar(60) NOT NULL,
    [telefono] varchar(15) NOT NULL,
    [correo] nvarchar(100) NOT NULL,
    [direccion] nvarchar(150) NOT NULL,
    [fecha_registro] date NOT NULL,
    CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED ([id_cliente] ASC),
    CONSTRAINT [UQ_Cliente_cedula] UNIQUE ([cedula] ASC),
    CONSTRAINT [CK_Cliente_cedula] CHECK (LEN([cedula]) = 10)
);
GO

CREATE TABLE [dbo].[Salon] (
    [id_salon] int IDENTITY(1,1) NOT NULL,
    [nombre] nvarchar(60) NOT NULL,
    [capacidad] int NOT NULL,
    [ubicacion] nvarchar(120) NOT NULL,
    [precio_base] decimal(10,2) NOT NULL,
    CONSTRAINT [PK_Salon] PRIMARY KEY CLUSTERED ([id_salon] ASC),
    CONSTRAINT [CK_Salon_capacidad] CHECK ([capacidad] > 0),
    CONSTRAINT [CK_Salon_precio_base] CHECK ([precio_base] >= 0)
);
GO

CREATE TABLE [dbo].[Servicio] (
    [id_servicio] int IDENTITY(1,1) NOT NULL,
    [nombre] nvarchar(60) NOT NULL,
    [categoria] nvarchar(40) NOT NULL,
    [descripcion] nvarchar(200) NULL,
    [precio_unitario] decimal(10,2) NOT NULL,
    CONSTRAINT [PK_Servicio] PRIMARY KEY CLUSTERED ([id_servicio] ASC),
    CONSTRAINT [CK_Servicio_precio_unitario] CHECK ([precio_unitario] >= 0)
);
GO

CREATE TABLE [dbo].[Paquete] (
    [id_paquete] int IDENTITY(1,1) NOT NULL,
    [nombre] nvarchar(60) NOT NULL,
    [descripcion] nvarchar(200) NULL,
    [precio_total] decimal(10,2) NOT NULL,
    CONSTRAINT [PK_Paquete] PRIMARY KEY CLUSTERED ([id_paquete] ASC),
    CONSTRAINT [UQ_Paquete_nombre] UNIQUE ([nombre] ASC),
    CONSTRAINT [CK_Paquete_precio_total] CHECK ([precio_total] >= 0)
);
GO

CREATE TABLE [dbo].[Empleado] (
    [id_empleado] int IDENTITY(1,1) NOT NULL,
    [cedula] varchar(10) NOT NULL,
    [nombres] nvarchar(60) NOT NULL,
    [apellidos] nvarchar(60) NOT NULL,
    [cargo] nvarchar(40) NOT NULL,
    [telefono] varchar(15) NOT NULL,
    [correo] nvarchar(100) NOT NULL,
    [fecha_ingreso] date NOT NULL,
    CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED ([id_empleado] ASC),
    CONSTRAINT [UQ_Empleado_cedula] UNIQUE ([cedula] ASC),
    CONSTRAINT [CK_Empleado_cedula] CHECK (LEN([cedula]) = 10)
);
GO

CREATE TABLE [dbo].[Evento] (
    [id_evento] int IDENTITY(1,1) NOT NULL,
    [id_cliente] int NOT NULL,
    [id_tipo_evento] int NOT NULL,
    [id_salon] int NOT NULL,
    [nombre_evento] nvarchar(100) NOT NULL,
    [fecha_evento] date NOT NULL,
    [hora_inicio] time(0) NOT NULL,
    [hora_fin] time(0) NOT NULL,
    [num_invitados] int NOT NULL,
    [estado] nvarchar(20) NOT NULL,
    CONSTRAINT [PK_Evento] PRIMARY KEY CLUSTERED ([id_evento] ASC),
    CONSTRAINT [FK_Evento_Cliente] FOREIGN KEY ([id_cliente]) REFERENCES [dbo].[Cliente] ([id_cliente]),
    CONSTRAINT [FK_Evento_TipoEvento] FOREIGN KEY ([id_tipo_evento]) REFERENCES [dbo].[TipoEvento] ([id_tipo_evento]),
    CONSTRAINT [FK_Evento_Salon] FOREIGN KEY ([id_salon]) REFERENCES [dbo].[Salon] ([id_salon]),
    CONSTRAINT [CK_Evento_invitados] CHECK ([num_invitados] > 0),
    CONSTRAINT [CK_Evento_horario] CHECK ([hora_fin] > [hora_inicio]),
    CONSTRAINT [CK_Evento_estado] CHECK ([estado] IN (N'Pendiente', N'Confirmado', N'En curso', N'Realizado', N'Cancelado'))
);
GO

CREATE TABLE [dbo].[PaqueteServicio] (
    [id_paquete] int NOT NULL,
    [id_servicio] int NOT NULL,
    [cantidad] int NOT NULL,
    CONSTRAINT [PK_PaqueteServicio] PRIMARY KEY CLUSTERED ([id_paquete] ASC, [id_servicio] ASC),
    CONSTRAINT [FK_PaqueteServicio_Paquete] FOREIGN KEY ([id_paquete]) REFERENCES [dbo].[Paquete] ([id_paquete]) ON DELETE CASCADE,
    CONSTRAINT [FK_PaqueteServicio_Servicio] FOREIGN KEY ([id_servicio]) REFERENCES [dbo].[Servicio] ([id_servicio]) ON DELETE CASCADE,
    CONSTRAINT [CK_PaqueteServicio_cantidad] CHECK ([cantidad] > 0)
);
GO

CREATE TABLE [dbo].[EventoPaquete] (
    [id_evento] int NOT NULL,
    [id_paquete] int NOT NULL,
    [fecha_contrato] date NOT NULL,
    CONSTRAINT [PK_EventoPaquete] PRIMARY KEY CLUSTERED ([id_evento] ASC, [id_paquete] ASC),
    CONSTRAINT [FK_EventoPaquete_Evento] FOREIGN KEY ([id_evento]) REFERENCES [dbo].[Evento] ([id_evento]) ON DELETE CASCADE,
    CONSTRAINT [FK_EventoPaquete_Paquete] FOREIGN KEY ([id_paquete]) REFERENCES [dbo].[Paquete] ([id_paquete]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[EventoServicio] (
    [id_evento] int NOT NULL,
    [id_servicio] int NOT NULL,
    [cantidad] int NOT NULL,
    [subtotal] decimal(10,2) NOT NULL,
    CONSTRAINT [PK_EventoServicio] PRIMARY KEY CLUSTERED ([id_evento] ASC, [id_servicio] ASC),
    CONSTRAINT [FK_EventoServicio_Evento] FOREIGN KEY ([id_evento]) REFERENCES [dbo].[Evento] ([id_evento]) ON DELETE CASCADE,
    CONSTRAINT [FK_EventoServicio_Servicio] FOREIGN KEY ([id_servicio]) REFERENCES [dbo].[Servicio] ([id_servicio]) ON DELETE CASCADE,
    CONSTRAINT [CK_EventoServicio_cantidad] CHECK ([cantidad] > 0),
    CONSTRAINT [CK_EventoServicio_subtotal] CHECK ([subtotal] >= 0)
);
GO

CREATE TABLE [dbo].[AsignacionEvento] (
    [id_asignacion] int IDENTITY(1,1) NOT NULL,
    [id_evento] int NOT NULL,
    [id_empleado] int NOT NULL,
    [rol] nvarchar(40) NOT NULL,
    [horas_trabajadas] decimal(5,2) NOT NULL,
    CONSTRAINT [PK_AsignacionEvento] PRIMARY KEY CLUSTERED ([id_asignacion] ASC),
    CONSTRAINT [FK_AsignacionEvento_Evento] FOREIGN KEY ([id_evento]) REFERENCES [dbo].[Evento] ([id_evento]),
    CONSTRAINT [FK_AsignacionEvento_Empleado] FOREIGN KEY ([id_empleado]) REFERENCES [dbo].[Empleado] ([id_empleado]),
    CONSTRAINT [UQ_AsignacionEvento] UNIQUE ([id_evento] ASC, [id_empleado] ASC, [rol] ASC),
    CONSTRAINT [CK_AsignacionEvento_horas] CHECK ([horas_trabajadas] > 0)
);
GO

CREATE TABLE [dbo].[Factura] (
    [id_factura] int IDENTITY(1,1) NOT NULL,
    [id_evento] int NOT NULL,
    [fecha_emision] date NOT NULL,
    [subtotal] decimal(10,2) NOT NULL,
    [iva] decimal(10,2) NOT NULL,
    [total] decimal(10,2) NOT NULL,
    [estado] nvarchar(20) NOT NULL,
    CONSTRAINT [PK_Factura] PRIMARY KEY CLUSTERED ([id_factura] ASC),
    CONSTRAINT [UQ_Factura_id_evento] UNIQUE ([id_evento] ASC),
    CONSTRAINT [FK_Factura_Evento] FOREIGN KEY ([id_evento]) REFERENCES [dbo].[Evento] ([id_evento]),
    CONSTRAINT [CK_Factura_subtotal] CHECK ([subtotal] >= 0),
    CONSTRAINT [CK_Factura_iva] CHECK ([iva] >= 0),
    CONSTRAINT [CK_Factura_total] CHECK ([total] >= 0),
    CONSTRAINT [CK_Factura_estado] CHECK ([estado] IN (N'Pendiente', N'Pagada', N'Anulada'))
);
GO

CREATE TABLE [dbo].[Pago] (
    [id_pago] int IDENTITY(1,1) NOT NULL,
    [id_factura] int NOT NULL,
    [fecha_pago] date NOT NULL,
    [monto] decimal(10,2) NOT NULL,
    [metodo_pago] nvarchar(30) NOT NULL,
    CONSTRAINT [PK_Pago] PRIMARY KEY CLUSTERED ([id_pago] ASC),
    CONSTRAINT [FK_Pago_Factura] FOREIGN KEY ([id_factura]) REFERENCES [dbo].[Factura] ([id_factura]) ON DELETE CASCADE,
    CONSTRAINT [CK_Pago_monto] CHECK ([monto] > 0),
    CONSTRAINT [CK_Pago_metodo] CHECK ([metodo_pago] IN (N'Efectivo', N'Transferencia', N'Tarjeta', N'Cheque'))
);
GO

INSERT INTO [dbo].[TipoEvento] ([nombre], [descripcion]) VALUES
(N'Bodas', N'Celebraciones de matrimonio'),
(N'Cumpleaños', N'Celebraciones de cumpleaños'),
(N'Eventos corporativos', N'Reuniones y eventos empresariales'),
(N'Quinceañeras', N'Celebración de los quince años'),
(N'Bautizos', N'Celebraciones de bautizo'),
(N'Graduaciones', N'Celebraciones de graduación');
GO

INSERT INTO [dbo].[Servicio] ([nombre], [categoria], [descripcion], [precio_unitario]) VALUES
(N'Catering', N'Alimentación', N'Servicio de comida para invitados', 150.00),
(N'Barra de bebidas', N'Alimentación', N'Bebidas y coctelería', 90.00),
(N'DJ', N'Entretenimiento', N'Música y animación musical', 120.00),
(N'Decoración', N'Ambientación', N'Decoración del salón', 200.00),
(N'Fotografía', N'Registro', N'Servicio fotográfico del evento', 130.00),
(N'Torta', N'Alimentación', N'Torta personalizada', 80.00),
(N'Animación', N'Entretenimiento', N'Animadores para los invitados', 100.00),
(N'Transporte', N'Logística', N'Transporte de invitados', 110.00);
GO
