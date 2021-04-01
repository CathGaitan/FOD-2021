program UnMaestro3Detalles;
const 
    valoralto='9999';
type
    producto = record
        cod:string[4];
        descripcion:string[30];
        pu:real;
        cant:integer;
    end;
    
    venta_prod = record
        cod:string[4];
        cant_vendida:integer;
    end;
    
    detalle = file of venta_prod;
    maestro = file of producto;

var 
    mae1:maestro; //archivo maestro
    regM:producto; //registro MAESTRO
    det1:detalle; //archivo detalle1 
    det2:detalle; //archivo detalle1 
    det3:detalle; //archivo detalle1
    regD1:venta_prod; //registro DETALLE1
    regD2:venta_prod; //registro DETALLE2
    regD3:venta_prod; //registro DETALLE3
    min:venta_prod; //para averiguar el minimo de los 3
    total:integer;

{----------------------------------------------------------------------------}

procedure Leer (var archivoDeta:detalle; var datoD:venta_prod);
begin
    if (not EOF(archivoDeta)) then
        read(archivoDeta,datoD) //en datoD=el dato apuntado en archivoDeta
    else
        datoD.cod:=valoralto; //para cortar el while 
end;

{----------------------------------------------------------------------------}

procedure minimo (var r1,r2,r3,min:venta_prod);
begin
    if  (r1.cod<=r2.cod) and (r1.cod<=r3.cod) then begin
        min:=r1;
        leer(det1,r1);
    end
    else 
        if (r2.cod <= r3.cod) then begin
            min:=r2;
            leer(det2,r2)
        end
        else begin
            min:=r3;
            leer(det3,r3)
        end;
    end;

{----------------------------------------------------------------------------}

begin
    assign(mae1,'maestro.data'); 
    assign(det1,'detalle1.data'); // asigno a mis variables un
    assign(det2,'detalle2.data'); // lugar fisico donde guardarse
    assign(det3,'detalle3.data'); 
    reset(mae1); 
    reset(det1); // los abro para poder
    reset(det2); // hacer lectura
    reset(det3); 
    read(mae1,regM); // en regM=dato apuntado en el maestro
    leer(det1,regD); 
    leer(det2,regD2); //si no EOF guardo en regD=detalle, sino asigno valoralto para cortar while
    leer(det3,regD3);
    minimo(regD1,regD2,regD3,min); // busco el codigo minimo entre los tres registros detalles
    while (min.cod <> valoralto) do begin //mientras el archivo detalle no termine
        read(mae1,regM);
        while (regm.cod <> min.cod) do // mientras mi codigo no cambie
            read(mae1,regM);
        while(regm.cod = min.cod) do begin
            regM.cant:=regM.cant-min.cant_vendida;
            minimo(regD1,regD2,regD3,min);
        end;
        seek(mae1,filepos(mae1)-1); // reubico el puntero (desacomodo el read anterior)
        write(mae1,regM); //actualizo mi archivo maestro
    end;
    close(mae1); 
    close(det1); // cierro mis
    close(det2); // archivos
    close(det3);
end.