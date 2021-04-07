{Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el servidor
de correo genera un archivo con la siguiente información: nro_usuario, cuentaDestino,
cuerpoMensaje. Este archivo representa todos los correos enviados por los usuarios en un día
determinado. Ambos archivos están ordenados por nro_usuario y se sabe que un usuario
puede enviar cero, uno o más mails por día.
a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema}
program ServidorCorreo;
const
    valoralto=9999;
type
    logs=record
        nrousuario:integer;
        nombreUsuario:String[20];
        nombre:String[20];
        apellido:String[20];
        cantidadMailEnviados:integer;
    end;

    correo=record
        nrousuario:integer;
        cuentaDestino:String[20];
        cuerpoMensaje:String[20];
    end;
    
    maestro=file of logs;
    detalle=file of correo;

{-------------------------------------------------------------------------------------}

procedure Leer (var archivoDeta:detalle; var datoD:correo);
begin
    if (not EOF(archivoDeta)) then
        read(archivoDeta,datoD) //en datoD=el dato apuntado en archivoDeta
    else
        datoD.nrousuario:=valoralto; //para cortar el while 
end;
{-------------------------------------------------------------------------------------}

procedure ActualizarLog();
var
    mae:maestro;
    det:detalle;
    regM:logs;
    regD:correo;
    auxnro:integer;
    cantMails:integer;
begin
    assign(mae,'logmail');
    assign(det,'detalle');
    reset(mae);
    reset(det);
    read(mae,regM);
    leer(det,regD);
    while (regD.nrousuario <> valoralto) do begin
        auxnro:=regD.nrousuario; //guardo mi nrousuario detalle
        cantMails:=0;
        while (auxnro = regD.nrousuario) do begin //salgo si: 1)cambio el regDetalle 2)Se llego al final del archivo
            cantMails:=cantMails+1;
            leer(det,regD);
        end;
        while (regM.nrousuario <> auxnro) do
            read(mae,regM); //busco ese codigo en el maestro
        regM.cantidadMailEnviados:=regM.cantidadMailEnviados+cantMails;
        seek(mae,FilePos(mae)-1);
        write(mae,regM);
        if (not EOF(mae)) then //avanzo en el maestro
            read(mae,regM);
    end;
    close(mae);
    close(det);
end;
{-------------------------------------------------------------------------------------}

procedure GenerarTxt();
var
    det:detalle;
    mae:maestro;
    texto:text;
    regD:correo;
    regM:logs;
    totalMails:integer;
begin
    assign(det,'detalle');
    reset(det);
    assign(mae,'logmail');
    reset(mae);
    assign(texto,'txtDetalle');
    rewrite(texto);

    leer(det,regD);
    while(regD.nrousuario <> valoralto) or (not EOF(mae))do begin
        totalMails:=0;
        read(mae,regM);
        writeln(texto,' ------------');
        writeln(texto,' Usuario nro ',regM.nrousuario);
        writeln(' Usuario nro',regM.nrousuario);
        if (regD.nrousuario = regM.nrousuario) then begin
            while(regD.nrousuario=regM.nrousuario) do begin
                totalMails:=totalMails+1;
                leer(det,regD);
            end;
        end 
        else
            leer(det,regD);
        writeln(texto,' Envio ',totalMails,' mensajes');
        writeln(' Envio ',totalMails,' mensajes');
    end;
    close(mae);
    close(det);
end;
{-------------------------------------------------------------------------------------}

procedure ExportarATxtMaestro();
var
    texto:Text;
    r:logs;
    archivoMae:maestro;
begin
    assign(archivoMae,'logmail');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'TXTMAESTRO');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' nro usuario: ',nrousuario);
          writeln(texto,' cant mails enviados: ',cantidadMailEnviados);
        end;
    end;
    close(texto);
    close(archivoMae);
end;
{-------------------------------------------------------------------------------------}
var
    opcion:integer;
begin
    writeln('Que accion quiere realizar?: ');
    writeln('OPCION 1: actualizar el archivo de logeos');
    writeln('OPCION 2: Pasar a txt el archivo detalle');
    writeln('OPCION 3: pasar a txt el maestro');
    write('Usted va a elegir la opcion: ');
    readln(opcion);
    case opcion of
        1:ActualizarLog();
        2:GenerarTxt();
        3:ExportarATxtMaestro();
    end;
end.