program CrearBinarioMaestro;
type
    tiempo=record
        dia:1..31;
        mes:1..12;
        anio:integer;
    end;
    infoAccesos=record
        fecha:tiempo;
        idUsuario:integer;
        tiempoAcceso:real;
    end;
    maestro=file of infoAccesos;
{----------------------------------------------------------------------}

procedure LeerAcceso(var i:infoAccesos);
begin
    writeln('----ACCESO A LA PAGINA-----');
    writeln('**FECHA** ');
    write('Anio: ');
    readln(i.fecha.anio);
    if (i.fecha.anio <> 9999) then begin
        write('Mes: ');
        readln(i.fecha.mes);
        write('Dia: ');
        readln(i.fecha.dia);
        write('ID Usuario: ');
        readln(i.idUsuario);
        write('Tiempo de acceso a la pagina: ');
        readln(i.tiempoAcceso);
    end;
end;

{----------------------------------------------------------------------}
var
    ArchivoMaestro:maestro;
    i:infoAccesos;
begin
    assign(archivoMaestro,'maestro');
    Rewrite(archivoMaestro);
    writeln('Escribir los accesos ordenado por: año, mes, dia e idUsuario');
    LeerAcceso(i);
    while (i.fecha.anio <> 9999) do begin
        write(archivoMaestro,i);
        LeerAcceso(i);
    end;
    close(archivoMaestro);
end.