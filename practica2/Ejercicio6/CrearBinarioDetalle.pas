program CrearBinarioDetalle;
const
    dimF=3;
type
    regDetalle=record
        cod:integer;
        cantvendida:integer;
    end;
    detalle=file of regDetalle;
    vecDetalle=array[1..dimF] of detalle;
{----------------------------------------------------------------}

procedure LeerProductoDetalle(var p:regDetalle);
begin
    WriteLn('---PRODUCTO DETALLE----');
    write('Codigo: ');
    readln(p.cod);
    if(p.cod <> 9999) then begin
        write('Cantidad vendida: ');
        readln(p.cantvendida);
    end;
end;

{----------------------------------------------------------------}
var
    i:integer;
    iString:String;
    vectorArc:vecDetalle;
    p:regDetalle;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalle'+iString);
        rewrite(vectorArc[i]); //creo mi detalle
        LeerProductoDetalle(p);
        while (p.cod <> 9999) do begin
            write(vectorArc[i],p);
            LeerProductoDetalle(p);
        end;
    end;
    for i:=1 to dimF do
        close(vectorArc[i]);
end.