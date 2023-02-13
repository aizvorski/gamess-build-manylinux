#!/bin/bash
set -x

# Install dependencies
yum install -y csh less nano
yum install -y openblas-devel.x86_64 openblas-static.x86_64
yum install -y lapack-devel.x86_64 lapack64-static.x86_64
# this is necessary for fully static builds
yum install -y glibc-static

# Unpack
tar xzf /shared/gamess-source-2022.2.tgz -C /shared
cp /shared/install.info /shared/gamess/

# Compile
cd /shared/gamess/ && ./compall >& compall.log

# Link
# mostly-static: dynamically links libc libm and libpthread, static everything else
cd /shared/gamess/object && gcc -o /shared/gamess/gamess.00.x -fopenmp -I/shared/gamess/object gamess.o gamess_version.o unport.o util.o aldeci.o algnci.o basccn.o basecp.o basext.o basg3l.o bashuz.o bashz2.o baskar.o basminix.o basn21.o basn31.o baspcn.o basg3x.o bassto.o casino.o ccaux.o ccddi.o ccqaux.o ccquad.o ccsdt.o ceeis.o cepa.o cnglob.o chgpen.o cimf.o ciminf.o cimi.o cimlib.o cimsub.o cisgrd.o comp.o cosmo.o cosprt.o cphf.o cpmchf.o cprohf.o cpuhf.o dccc.o dcgrd.o dcgues.o dcint2.o dclib.o dcmp2.o dcscf.o dctran.o ddilib.o delocl.o demrpt.o dft.o dftaux.o dftbfo.o dftbgr.o dftbhs.o dftblb.o dftbpb.o dftbsk.o dftbtd.o dftbx.o dftdis.o dftfun.o dftgrd.o dftint.o dftxca.o dftxcb.o dftxcc.o dftxcd.o dftxce.o dftxcf.o dftxcg.o diab.o dmulti.o drc.o eaipcc.o ecp.o ecpder.o ecplib.o ecppot.o efpmodule.o efchtr.o efdrvr.o efelec.o efgrd2.o efgrda.o efgrdb.o efgrdc.o efinp.o efinta.o efintb.o efmo.o efmograd.o efmograd_es.o efmograd_exrep.o efmograd_disp.o efmograd_pol.o efpaul.o efpcm.o efpcov.o efpfmo.o eftei.o eftei_genr70.o eftei_genr03.o eftei_eric.o eigen.o elglib.o elgloc.o elgscf.o eomcc.o ewald.o excorr.o ffield.o fmo.o fmoafo.o fmocp.o fmoesd.o fmogrd.o fmoh1a.o fmoh2a.o fmoh2b.o fmoh2c.o fmohss.o fmoint.o fmoio.o fmolib.o fmomm.o fmopbc.o fmoprp.o frfmt.o fsodci.o g3.o globop.o gmcpt.o gradex.o guess.o grd1.o grd2a.o grd2b.o grd2c.o gugdga.o gugdgb.o gugdm.o gugdm2.o gugdrt.o gugem.o gugsrt.o gvb.o hess.o hss1a.o hss1b.o hss1c.o hss2a.o hss2b.o hss2c.o inputa.o inputb.o inputc.o int1.o int2a.o int2b.o int2c.o int2d.o int2f.o int2g.o int2r.o int2s.o iolib.o ivocas.o lagran.o local.o locatd.o loccd.o locpol.o locsvd.o lrd.o lut.o mod_lutiotc.o modmcpdft.o mcpdft.o mcpgrd.o mcpinp.o mcpint.o mcpl10.o mcpl20.o mcpl30.o mcpl40.o mcpl50.o mcpl60.o mcpl70.o mcpl80.o mccas.o mcjac.o mcqdpt.o mcqdwt.o mcqud.o mcscf.o mctwo.o mctwo-defensive.o mdefp.o mexing.o mltfmo.o mm23.o modmnfun.o modcc.o morokm.o mnsol.o mp2.o mp2ddi.o mp2grd.o mp2grd-defensive.o mp2gr2.o mp2ims.o mod_sformas.o mpcdat.o mpcdatpm6.o mpcgrd.o mpchbond.o mpcint.o mpcmol.o mpcmsc.o mpcpcm.o mrsf.o mthlib.o nameio.o nebpath.o namd.o nmr.o optcix.o ordint.o ormas1.o ormpt2.o parley.o pcm.o pcmcav.o pcmcv2.o pcmder.o pcmdis.o pcmhss.o pcmief.o pcmpol.o pcmvch.o prpamm.o prpel.o prplib.o prppop.o qeigen.o qfmm.o qmfm.o qrel.o quanpoa.o quanpoa_1.o quanpob.o quanpoc.o quanpod.o quanpoe.o quanpof.o raman.o reks.o reorg.o rhfuhf.o ricab.o riint.o rimp2.o rimp2_1.o rimp2omp.o rimp2grd.o rmd.o rmddat.o rmdgen.o rmdwrk.o rmdrun.o roeom.o rohfcc.o rxncrd.o ryspol.o scflib.o scfmi.o scrf.o secor.o sfdft.o sfgrad.o sobrt.o soffac.o solib.o sozeff.o statpt.o hrmrst.o surf.o svpchg.o svpinp.o svpleb.o symhi.o symorb.o symslc.o tddft.o tduprp.o tddefp.o tddfun.o tddfxc.o tddgrd.o tddint.o tddnlr.o tddxca.o tddxcc.o tddxcd_m05.o tddxcd_m06.o tddxcd_m08.o tddxcd_pkzb.o tddxcd_revtpss.o tddxcd_tpss.o tddxcd_vs98.o tddxce.o tdhf.o tdx.o tdxio.o tdxitr.o tdxni.o tdxprp.o trans.o trfdm2.o trnstn.o trudge.o umpddi.o utddft.o utdgrd.o vibanl.o vm2_module.o vscf.o vvos.o zapddi.o zmatrx.o mod_nosp_basis.o mod_grid_storage.o mod_dft_partfunc.o mod_dft_molgrid.o mod_dft_fuzzycell.o mod_dft_gridint.o constants.o gausshermite.o modules_dft.o utils_strings.o modules_common.o messages.o fcidump.o stubcc3.o libxc_empty.o modmdi_empty.o qmmm.o vbdum.o neostb.o nbostb.o vm2_stub.o cchdmy.o params.o mx_limits.o prec.o grd2_consts.o blkint.o ompmod_tools.o ompmod.o ompgrd2.o mod_shell_tools.o mod_gauss_hermite.o omp_int1.o mod_1e_primitives.o omp_grd1.o omp_fmo.o omp_fmogrd1.o omp_fmogrd2.o omp_pcm.o efteiomp.o riccutils.o riccints.o riccdiag.o riccrhf.o mpqcst.o /usr/lib64/libopenblas64.a /usr/lib64/liblapack64.a /usr/lib64/libopenblas64.a serial.o -static-libgcc -Wl,-Bstatic -lgfortran -lquadmath -Wl,-Bdynamic -lm -pthread

# Cleanup
# rm -rf /shared/gamess/object
