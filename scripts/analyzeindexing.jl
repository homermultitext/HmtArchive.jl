using HmtArchive.Analysis
using CitableBase, CitableObject, CitableText
using CitablePhysicalText

outputdir = joinpath(pwd(), "scratch", "indexingreport")
mkpath(outputdir)


# Just gonna make these global in this little script
# rather than pass these huge data sets around all the time.
dse = hmt_dse()[1]
commentary = hmt_commentary()[1]

mslist = hmt_codices()
vaurn = Cite2Urn("urn:cite2:hmt:msA.v1:")
va = filter(ms -> urn(ms) == vaurn, mslist)[1]


function pagereport(pg)
    mdlines = []
    pagetexts = textsforsurface(pg, dse)

    push!(mdlines, "## Text indexing for $(objectcomponent(pg))\n")
    push!(mdlines, "$(length(pagetexts)) citable passages of text indexed to page $(objectcomponent(pg))")


    join(mdlines, "\n")
end



for pg in va.pages[30:31]
    pgref = objectcomponent(pg.urn)
    outfile = joinpath(outputdir, pgref * ".md")
    open(outfile, "w") do io
        write(io, pagereport(pg.urn))
    end
end