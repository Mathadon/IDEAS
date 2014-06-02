within IDEAS.Fluid.HeatExchangers.GroundHeatExchanger.Borefield.BaseClasses.BoreHoles.Examples;
model SingleBoreHoleSerStepLoadScript "SingleBoreHoleSer with step input load "
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

   parameter Data.StepResponse.example steRes "generic step load parameter"
     annotation (Placement(transformation(extent={{-18,-76},{-8,-66}})));
   parameter Data.Advanced.example adv "Advanced parameters"
     annotation (Placement(transformation(extent={{-2,-76},{8,-66}})));
   parameter Data.SoilData.example soi
     annotation (Placement(transformation(extent={{14,-76},{24,-66}})));
   parameter Data.FillingData.example fill
    "Thermal properties of the filling material"
     annotation (Placement(transformation(extent={{30,-76},{40,-66}})));
   parameter Data.GeometricData.example geo
    "Geometric charachteristic of the borehole"
     annotation (Placement(transformation(extent={{46,-76},{56,-66}})));

  BoreHoles.SingleBoreHolesInSerie borHolSer(
    redeclare each package Medium = Medium,
    soi=soi,
    fill=fill,
    geo=geo,
    adv=adv,
    dp_nominal=10000,
    m_flow_nominal=steRes.m_flow,
    T_start=steRes.T_ini) "Borehole heat exchanger" annotation (Placement(
        transformation(extent={{-12,-50},{12,-26}}, rotation=0)));

  Buildings.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium,
      nPorts=2) "Sink"
    annotation (Placement(transformation(extent={{22,-34},{34,-22}})));

  Modelica.Blocks.Sources.Step step(height=1)
    annotation (Placement(transformation(extent={{58,-18},{46,-6}})));

  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-46,-24},{-34,-12}})));
  Movers.Pump                               pum(
    redeclare package Medium = Medium,
    m_flow_nominal=steRes.m_flow,
    m_flow(start=steRes.m_flow),
    T_start=steRes.T_ini,
    useInput=true)
    annotation (Placement(transformation(extent={{-12,10},{-32,-10}})));

  HeaterCoolerPrescribed                                hea(
    redeclare package Medium = Medium,
    m_flow_nominal=steRes.m_flow,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow(start=steRes.m_flow),
    T_start=steRes.T_ini,
    Q_flow_nominal=steRes.q_ste*geo.hBor*geo.nbSer,
    p_start=100000)
    annotation (Placement(transformation(extent={{30,10},{10,-10}})));
equation
  connect(pum.port_b, borHolSer.port_a) annotation (Line(
      points={{-32,0},{-58,0},{-58,-38},{-12,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, sin.ports[1]) annotation (Line(
      points={{30,0},{66,0},{66,-26.8},{34,-26.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a,hea. port_b) annotation (Line(
      points={{-12,0},{10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, hea.u) annotation (Line(
      points={{45.4,-12},{40,-12},{40,-6},{32,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flowSet) annotation (Line(
      points={{-33.4,-18},{-22,-18},{-22,-10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea.port_a, borHolSer.port_b) annotation (Line(
      points={{30,0},{66,0},{66,-38},{12,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),graphics),
    experimentSetupOutput,
    Diagram,
    Documentation(info="<html>
<p>

</p>
</html>", revisions="<html>
<ul>
</ul>
</html>"),
    experiment(
      StopTime=3.1536e+007,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
        graphics));
end SingleBoreHoleSerStepLoadScript;
