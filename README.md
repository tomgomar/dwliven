Instalación

### 1. Clonar el repositorio en tu carpeta de trabajo.

> p.e. C:/Proyectos/dwpb

### 2. Importar la BBDD

Se trata de [importar un fichero .bacpac](https://docs.microsoft.com/en-us/sql/relational-databases/data-tier-applications/import-a-bacpac-file-to-create-a-new-user-database)

* En el menu de la izquierda "Object Explorer" -> botón derecho "Databases" -> "Import Data-tier Application"
* Ajustar los permisos: _Security_ -> _Logins_ -> Elige tu usuario _(sa)_ -> _User Mapping_ -> _Elige la BBDD_ -> _db_datareader, db_datawriter and db_ddladmin_

![](https://doc.dynamicweb.com/Admin/Public/GetImage.ashx?width=1280&crop=7&Compression=75&image=%2fFiles%2fImages%2fTechnical+how-tos%2fInstallLocal20_WrapDatabase4.png)

> Nota: El login es Administrator/Administrator

### 3. Ajustar globalsettings.aspx

> Solo si es necesario, por defecto ya está configurado en este repositorio

![](https://doc.dynamicweb.com/Admin/Public/GetImage.ashx?width=1280&crop=7&Compression=75&image=%2fFiles%2fImages%2fTechnical+how-tos%2fInstallLocal21_GlobalSettings.png)

### 4. Configurar IIS

* Crear un nuevo sitio web apuntando a la carpeta _Applications/Application (9.4.1)/_

> p.e. local.dwpb.com -> C:/Proyectos/dwpb/Applications/Application (9.4.1)/

* Añadir un directorio virtual _Files_ apuntando a la carpeta _Solutions/Rapido/Files/_

> p.e. local.pdwpb.com /Files -> C:/Proyectos/dwpb/Solutions/Rapido/Files/

![](https://doc.dynamicweb.com/Admin/Public/GetImage.ashx?width=1280&crop=7&Compression=75&image=%2fFiles%2fImages%2fTechnical+how-tos%2fInstallLocal16_VirtualDirectory.png)

> si no funciona y al poner localhost en el explorador sale en blanco, aegurarse de que esta marcada la
> casilla en Static Content: In Control Panel --> Programs --> Programs And Features --> Turn Windows features on or off -> Internet > > Information Services -> World Wide Web Services -> Common HTTP Features -> Static Content.

Información detallada en [Using a virtual /files directory](https://doc.dynamicweb.com/get-started/introduction/installation/installing-dynamicweb#6497)

### 5. Reconstruir indices

* Ir al [admin](your.localsolutionurl.dk/admin) y haz login como administrador
* _Settings_ > _Repositories_
* _Files repository_ -> _Files index_
* Debajo de _Builds_ click en el botón amarillo _Files_ para construir los indices
* Repite para los otros indices "PIM, Products & Secondary users"

> Información detallada en [Restoring a Rapido Database](https://doc.dynamicweb.com/get-started/introduction/installation/installing-rapido#sideNavTitle1-2)
