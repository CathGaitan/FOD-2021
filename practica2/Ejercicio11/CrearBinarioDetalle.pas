program CrearBinarioDetalle;
const
    dimF=2;
type
    regDetalle=record
        prov:String[20];
        codLocalidad:integer;
        alfabetizados:integer;
        encuestados:integer;
    end;
    detalle = file of regDetalle;
    vecDetalle=array[1..dimF] of detalle;

{----------------------------------------------------------------------}

procedure LeerCenso(var r:regDetalle);
begin
    writeln('----CENSO-----');
    write('Provincia: ');
    readln(r.prov);
    if (r.prov <> 'ZZZZ') then begin
        write('Codigo de localidad: ');
        readln(r.codLocalidad);
        write('Cantidad de gente alfabetizada: ');
        readln(r.alfabetizados);
        write('Cantidad de gente encuestada: ');
        readln(r.encuestados);
    end;
end;

{----------------------------------------------------------------------}
var
    i:integer;
    iString:String;
    vectorArc:vecDetalle;
    r:regDetalle;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalle'+iString);
        rewrite(vectorArc[i]); //creo mi detalle
        LeerCenso(r);
        while (r.prov <> 'ZZZZ') do begin
            write(vectorArc[i],r);
            LeerCenso(r);
        end;
    end;
    for i:=1 to dimF do
        close(vectorArc[i]);
end.