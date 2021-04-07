{La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de la
organización. En dicho servidor, se almacenan en un archivo todos los accesos que se realizan
al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y tiempo
de acceso al sitio de la organización. El archivo se encuentra ordenado por los siguientes
criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará el
año calendario sobre el cual debe realizar el informe}
program SoftwareX;
const
    valoralto=9999;
type
    tiempo=record
        dia:1..31;
        mes:1..12;
        anio:integer;
    end;
    infoAccesos=record
        fecha:tiempo;
        idUsuario:integer;
        tiempoAcceso:integer;
    end;
    maestro=file of infoAccesos;

{-----------------------------------------------------------}

procedure Leer(var archivo:maestro; var datoD:infoAccesos);
begin
    if(not EOF(archivo)) then
        read(archivo,datoD)
    else
        datoD.fecha.anio:=valoralto;
end;

{-----------------------------------------------------------}

procedure ImprimirDatos(var mae:maestro;var regM:infoAccesos; anio:integer);
var
    totalanio,totalmes,totaldia:integer;
    actualmes,actualdia:integer;
    actualusuario,tiempousuario:integer;
begin
    writeln('Anio: ',anio);
    totalanio:=0;
    while(regM.fecha.anio = anio) do begin
        totalmes:=0;
        actualmes:=regM.fecha.mes;
        writeln('   Mes ',actualmes);
        while((anio=regM.fecha.anio) and(actualmes=regM.fecha.mes)) do begin
            totaldia:=0;
            actualdia:=regM.fecha.dia;
            writeln('       Dia ',actualdia);
            while((anio=regM.fecha.anio) and (actualmes=regM.fecha.mes) and (actualdia=regM.fecha.dia)) do begin
                tiempousuario:=0;
                actualusuario:=regM.idUsuario;
                while((anio=regM.fecha.anio) and (actualmes=regM.fecha.mes) and (actualdia=regM.fecha.dia) and (actualusuario=regM.idUsuario)) do begin
                    tiempousuario:=tiempousuario+regM.tiempoAcceso;
                    leer(mae,regM); //voy a buscar otro anio
                end;
                writeln('               IdUsuario: ',actualusuario,' Tiempo total de acceso en el dia ',actualdia,' en el mes ',actualmes,': ',tiempousuario);
                totaldia:=totaldia+tiempousuario;
            end;
            writeln('           Tiempo total de acceso en el dia ',actualdia,' mes ',actualmes,': ',totaldia);
            totalmes:=totalmes+totaldia;
        end;
        writeln('       Tiempo total de acceso en el mes ',actualmes,': ',totalmes);
        totalanio:=totalanio+totalmes;
    end;
    writeln('Total tiempo de acceso en el ',anio,': ',totalanio);
end;
{-----------------------------------------------------------}
var
    mae:maestro;
    regM:infoAccesos;
    anio:integer;
    ok:boolean;
begin
    assign(mae,'maestro');
    reset(mae);
    ok:=false;
    write('Anio del que quiere ver su informe: ');
    readln(anio);
    while(not EOF(mae) and (not ok)) do begin
        read(mae,regM);
        if(regM.fecha.anio = anio) then //ya me queda el archivo posicionado en la
            ok:=true;           //posicion donde esta el anio que corresponde
    end;
    if(ok) then begin
        ImprimirDatos(mae,regM,anio);
    end
    else
        writeln('Anio no encontrado');
    close(mae);
end.