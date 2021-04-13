program CrearDetalle;
type
    detalle=file of integer;

{---------------------------------------------------------}
var
    ArchivoDetalle:detalle;
    codPrenda:integer;
begin
    assign(archivoDetalle,'detalle');
    Rewrite(archivoDetalle);
    write('Codigo de prenda que quedara obsoleta: ');
    readln(codPrenda);
    while (codPrenda <> 9999) do begin
        write(archivoDetalle,codPrenda);
        write('Codigo de prenda que quedara obsoleta: ');
        readln(codPrenda);
    end;
    close(archivoDetalle);
end.