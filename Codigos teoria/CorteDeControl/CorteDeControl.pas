//PRECONDICIONES
//Esta ORDENADO --> por provincia, ciudad y sucursal
//Puede haber ciudades con el mismo nombre en dif provincias
// Puede haber sucursales con el mismo nombre en dif ciudades
program CorteDeControl;
const
    valoralto='ZZZ';
type
    nombre=string[30];
    RegVenta=record
        vendedor:integer;
        montoVenta:real;
        sucursal:nombre;
        ciudad:nombre;
        provincia:nombre;
    end;
    Ventas=file of RegVenta;
var
    reg:RegVenta;
    archivo:Ventas;
    total,totalprov,totalciu,totalsuc:real;
    prov,ciu,sucu:nombre;
{-----------------------------------------------------------------------------}

procedure leer (var archivo:Ventas;var dato:RegVenta);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.provincia:=valoralto;
end;

{-----------------------------------------------------------------------------}
begin
    assign(archivo,'archivoventas');
    reset(archivo);
    leer(archivo,reg); //en reg=dato al que apunta mi archivo
    total:=0;
    while (reg.provincia <> valoralto) do begin //corte de control--> mientras que no se termine mi archivo
        writeln('Provincia: ',reg.provincia);
        prov:=reg.provincia; //guardo la provincia con la que estoy trabajando
        totalprov:=0;
        while (prov=reg.provincia) do begin //mientras sea la misma provincia, totalizo sus ventas
            writeln('Ciudad: ',reg.ciudad);
            totalciu:=0;
            ciu:=reg.ciudad;
            while (prov=reg.Provincia) and (ciu=reg.ciudad) do begin //mientras sea la misma prov y misma ciudad, totalizo
                writeln('Sucursal: ',reg.Sucursal);
                sucu:=reg.sucursal;
                totalsuc:=0;
                while (prov=reg.provincia) and (ciu=reg.ciudad) and (sucu=reg.sucursal) do begin //mientras misma prov,ciudad y sucursal
                    write('Vendedor: ',reg.Vendedor);
                    writeln(reg.montoVenta);
                    totalsuc:=totalsuc+reg.montoVenta;
                    leer(archivo,reg); // reg=proximo dato de mi archivo o corte de control si EOF
                end;
                writeln('Total Sucursal: ',totalsuc); //imprimo total sucursal si cambio la suc
                totalciu:=totalciu+totalsuc;
            end;
            writeln('Total ciudad: ',totalciu); //imprimo total ciudad si cambio la ciudad
            totalprov:=totalprov+totalciu;
        end;
        writeln('Total provincia: ',totalprov); //imprimo total provincia si cambio de provincia
        total:=total+totalprov;
        end;
    writeln('Total empresa: ',total); //imprimo total empresa
    close(archivo);
end.

