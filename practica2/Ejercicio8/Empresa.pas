program Empresa;
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