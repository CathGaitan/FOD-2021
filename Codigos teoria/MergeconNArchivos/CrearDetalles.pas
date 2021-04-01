program CrearDetalles;
const
    cantDet=3;
type
    vendedor=record
        cod:string[4];               
        producto:string[10];         
        montoVenta:real;        
    end;

    detalle=file of vendedor;
    arc_detalle=array[1..cantDet] of detalle; //vector de archivos detalle

{----------------------------------------------------------------------------------------------}

procedure LeerVendedor(var v:vendedor);
begin
    write('Codigo vendedor (max 4 numeros): ');
    readln(v.cod);
    write('Producto: ');
    readLn(v.producto);
    write('Monto de las ventas: ');
    readln(v.montoVenta);
end;

{----------------------------------------------------------------------------------------------}

var
    v:vendedor;
    i:integer;
    VectorArchivosDetalle:arc_detalle;
    iString:string;
begin
    for i:=1 to cantDet do begin
        Str(i,iString); //convierto el valor de i, en un string
        assign (VectorArchivosDetalle[i],'detalle'+iString+'.data'); //asigno espacio disco duro
        rewrite(VectorArchivosDetalle[i]);
        LeerVendedor(v);
        write(VectorArchivosDetalle[i],v);
    end;
end.