program CrearBinarioMaestro;
const
    valoralto=9999;
type
    fecha=record
        dia:1..31;
        mes:1..12;
        anio:integer;
    end;
    cliente=record
        cod:integer;
        nombre:string[20];
        apellido:string[20];
    end;
    venta=record
        fechaventa:fecha;
        clienteventa:cliente;
        montoventa:real;
    end;

    maestro=file of venta;

{----------------------------------------------------------------------}

procedure LeerVenta(var v:venta);
begin
    writeln('----VENTA-----');
    write('Codigo cliente: ');
    readln(v.clienteventa.cod);
    if (v.clienteventa.cod <> valoralto) then begin
        write('Nombre: ');
        readln(v.clienteventa.nombre);
        write('Apellido: ');
        readln(v.clienteventa.apellido);
        writeln('Fecha');
        write('Dia: ');
        readln(v.fechaventa.dia);
        write('Mes: ');
        readln(v.fechaventa.mes);
        write('Anio: ');
        readln(v.fechaventa.anio);
        write('Monto: ');
        readln(v.montoventa);
    end;
end;

{----------------------------------------------------------------------}
var
    ArchivoMaestro:maestro;
    v:venta;
begin
    assign(archivoMaestro,'maestro');
    Rewrite(archivoMaestro);
    LeerVenta(v);
    while (v.clienteventa.cod <> valoralto) do begin
        write(archivoMaestro,v);
        LeerVenta(v);
    end;
    close(archivoMaestro);
end.