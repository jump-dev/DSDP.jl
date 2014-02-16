using BinDeps

@BinDeps.setup

@unix_only begin
    libdsdp = library_dependency("libdsdp", aliases=["libdsdp.a", "libdsdp.so", "libdsdp.dylib"])
end

DSDPname = "DSDP5.8"

provides(Sources, URI("http://www.mcs.anl.gov/hs/software/DSDP/$DSDPname.tar.gz"),
    [libdsdp], os = :Unix, unpacked_dir="$DSDPname")

patchdir=BinDeps.depsdir(libdsdp)
srcdir = joinpath(patchdir,"src",DSDPname) 
libdir = joinpath(srcdir,"lib")
usrdir = BinDeps.usrdir(libdsdp)

if OS_NAME == :Darwin ext = "dylib" else ext = "so" end

provides(SimpleBuild,
    (@build_steps begin
        GetSources(libdsdp)
        CreateDirectory(joinpath(usrdir,"lib"))
        @build_steps begin
            ChangeDirectory(srcdir)
            `echo "DSDPROOT=$srcdir"` >> "make.include"
            `cat $patchdir/malloc.patch` |> `patch -N -p0`
            `cat $patchdir/matlab.patch` |> `patch -N -p0`
            `cat $patchdir/g2c_1.patch`  |> `patch -N -p0`
            `cat $patchdir/g2c_2.patch`  |> `patch -N -p0`
            `make`
            `cc -shared $libdir/libdsdp.a -o $usrdir/lib/libdsdp.$ext`
        end
    end),[libdsdp], os = :Unix)

@BinDeps.install [:libdsdp => :libdsdp]
