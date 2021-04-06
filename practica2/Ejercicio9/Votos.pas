{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa. Presentar
en pantalla un listado.
NOTA: La información se encuentra ordenada por código de provincia y código de localidad}
program Votos;
const
    valoralto=9999;
type
    mesas=record
        codprov:integer;
        codlocal:integer;
        numMesa:integer;
        cantVotos:integer;
    end;
    maestro=file of mesas;
{-----------------------------------------------------------------------------}

procedure leer (var archivo:maestro;var dato:mesas);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.codprov:=valoralto;
end;

{-----------------------------------------------------------------------------}

procedure ImprimirVotos(var mae:maestro);
var
    reg:mesas;
    total,totalprov,totallocal:integer;
    prov,localidad:integer;
begin
    leer(mae,reg);
    total:=0;
    while (reg.codprov <> valoralto) do begin
        writeln('-----------------------');
        writeln('Codigo provincia ',reg.codprov);
        totalprov:=0;
        prov:=reg.codprov;
        while (prov=reg.codprov) do begin
            writeln('-Codigo Localidad ',reg.codlocal);
            totallocal:=0;
            localidad:=reg.codlocal;
            while((prov=reg.codprov) and (localidad=reg.codlocal)) do begin
                totallocal:=totallocal+reg.cantVotos;
                Leer(mae,reg);
            end;
            writeln(' Total votos localidad: ',totallocal);
            totalprov:=totalprov+totallocal;
        end;
        writeln('Total votos provincia: ',totalprov);
        total:=total+totalprov;
    end;
    writeln('-----------------------');
    writeln('Total general de votos: ',total);
end;
{-----------------------------------------------------------------------------}
var
    mae:maestro;
begin
    assign(mae,'maestro');
    reset(mae);
    ImprimirVotos(mae);
    close(mae);
end.