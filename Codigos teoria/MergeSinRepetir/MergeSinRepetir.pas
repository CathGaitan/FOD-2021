program MergeSinRepetir;
const
    valoralto='9999';
type
    producto=record
        codigo:string[4];
        descripcion:string[30];
        pu:real;
        cant:integer;
    end;
    detalle = file  of producto;
    
var
    min,regD1,regD2,regD3:producto;
    det1,det2,det3,mae1:detalle;
    
{------------------------------------------------------------------------------}

procedure leer (var archivo: detalle; var dato:producto);
begin
    if (not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.codigo:=valoralto;
end;

{------------------------------------------------------------------------------}

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

{------------------------------------------------------------------------------}

begin
    assing(mae1,'maestro.data');
    assing(dat1,'detelle1.data');
    assing(dat2,'detalle2.data');
    assing(dat3,'detalle3.data');
    rewrite(mael1);
    reset(det1);
    reset(det2);
    reset(det3);
    leer(det1,regD1); //
    leer(det2,regD2);
    leer(det3,regD3);
    minimo(regD1,regD2,regD3,min); //busco el codigo minimo entre mis DETALLES
    while (min.codigo <> valoralto) do begin
        write(mael1,min); //escribo en mi archivo MAESTRO el minimo encontrado
        minimo(regD1,regD2,regD3,min); //busco el codigo minimo entre mis DETALLES
    end;
    close(det1);
    close(det2);
    close(det3);
    close(mael1);
end.

