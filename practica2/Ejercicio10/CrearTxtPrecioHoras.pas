program CrearTxtPrecioHoras;
const
    valoralto=9999;
type
    horas=record
        categoria:integer;
        precio:real;
    end;
{---------------------------------------------------------------}
var
    texto:text;
    h:horas;
    i:integer;
begin
    assign(texto,'txtConPrecioExtra');
    rewrite(texto);
    for i:=1 to 15 do begin
        writeln('Categoria ',i);
        h.categoria:=i;
        write('Precio: ');
        readln(h.precio);
        writeln(texto,' ',h.categoria,' ',h.precio:5:2);
    end;
    close(texto);
end.