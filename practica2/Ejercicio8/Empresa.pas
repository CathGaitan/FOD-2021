{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizado por cliente.
Para ello, se deberá informar por pantalla: los datos personales del cliente, el total mensual
(mes por mes cuánto compró) y finalmente el monto total comprado en el año por el cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año, mes,
día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron compras}
program Empresa;
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

{-------------------------------------------------------------------------}

procedure Leer(var archivoDeta:maestro; var datoD:venta);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.clienteventa.cod:=valoralto;
end;

{-------------------------------------------------------------------------}

function totalMesCliente(var regVenta:venta; var mae:maestro; anioAct,codCliente:integer):real;
var
    totalmes:real;
    mesActual:1..12;
begin
    mesActual:=regVenta.fechaventa.mes;
    totalmes:=0;
    while ((regVenta.clienteventa.cod <> valoralto) and (regVenta.clienteventa.cod = codCliente) and (regVenta.fechaventa.anio=anioAct)) do begin
        totalmes:=totalmes+regVenta.montoventa;
        leer(mae,regVenta);
    end;
    writeln('En el mes ',mesActual,' el cliente numero ',codCliente,' gasto ',totalmes:5:2,'$');
    totalMesCliente:=totalmes;
end;
{-------------------------------------------------------------------------}

function totalAnioCliente(var regVenta:venta; var mae:maestro; codCliente:integer):real;
var
    totalanio:real;
    anioActual:integer;
begin
    anioActual:=regVenta.fechaventa.anio;
    totalanio:=0;
    while ((regVenta.clienteventa.cod <> valoralto) and (regVenta.clienteventa.cod = codCliente) and (regVenta.fechaventa.anio=anioActual)) do
        totalanio:=totalanio+totalMesCliente(regVenta,mae,anioActual,codCliente);
    writeln('En el anio ',anioActual,' el cliente numero ',codCliente,' gasto ',totalanio:5:2,'$');
    totalAnioCliente:=totalanio
end;

{-------------------------------------------------------------------------}

procedure imprimirCliente(regVenta:venta);
begin
    writeln('-----CLIENTE------');
    writeln('Codigo cliente: ',regVenta.clienteventa.cod);
    writeln('Nombre: ',regVenta.clienteventa.nombre);
    writeln('Apellido: ',regVenta.clienteventa.apellido);
end;

{-------------------------------------------------------------------------}

procedure totalEmpresa(var mae:maestro);
var
    totalEmpresa:real;
    codCliente:integer;
    regVenta:venta;
begin
    leer(mae,regVenta);
    while(regVenta.clienteventa.cod <> valoralto) do begin
        codCliente:=regVenta.clienteventa.cod;
        imprimirCliente(regVenta);
        totalEmpresa:=0;
        while ((regVenta.clienteventa.cod <> valoralto)and(regVenta.clienteventa.cod=codCliente)) do 
            totalEmpresa:=totalEmpresa+totalAnioCliente(regVenta,mae,codCliente);
        writeln('La empresa en total gano ',totalEmpresa:5:2,'$');
    end;
end;

{-------------------------------------------------------------------------}
var
    mae:maestro;
begin
    assign(mae,'maestro');
    reset(mae);
    totalEmpresa(mae);
    close(mae);
end.