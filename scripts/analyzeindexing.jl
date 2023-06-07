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
    mdlines = ["## Text indexing for $(objectcomponent(pg))\n"]
    
    pagetexts = textsforsurface(pg, dse)
    push!(mdlines, "\n##### $(length(pagetexts)) citable passages of text indexed to page $(objectcomponent(pg))")

	scholiadse = filter(u -> startswith(workcomponent(u), "tlg5026"), pagetexts)    	
    hdr1 = "\n##### **$(length(scholiadse))** scholia have DSE records for this page.\n"



    indexed = []
    iliadlines = filter(u -> startswith(workcomponent(u), "tlg0012.tlg001"), pagetexts)
	for ln in iliadlines
		scholia = filter(pr -> pr[2] == ln, commentary.commentary)
		if isempty(scholia)
		else
			reff = map(pr -> pr[1], scholia)
			for r in reff
				push!(indexed, r)
			end
		end
	end

    dsenotindexed = []	
	for s in scholiadse
		if s in indexed
		else
			push!(dsenotindexed, string(s))
		end
	end
	isempty(dsenotindexed) ? push!(mdlines, "All scholia in DSE records are indexed to an *Iliad* line on this page.") : push!(mdlines, "**$(length(dsenotindexed))** scholia in DSE records are *not* indexed to an *Iliad* line on this page.")
	push!(mdlines, "")
	for s in dsenotindexed
		push!(mdlines, "1. " * string(s))
	end



	hdr2 = "\n##### **$(length(indexed))** scholia in XML editions are indexed to *Iliad* lines on this page.\n"
    push!(mdlines, hdr2)

    indexednotindse = []
	for s in indexed
		if s in scholiadse
		else
			push!(indexednotindse, string(s))
		end
	end
	isempty(indexednotindse) ? push!(mdlines, "All scholia indexed to an *Iliad* line on this page also have a DSE record.") : push!(mdlines, "**$(length(indexednotindse))** scholia indexed to *Iliad* lines on this page do *not* appear in DSE records.")
	push!(mdlines, "")
	for s in indexednotindse
		push!(mdlines, "1. " * string(s))
	end

    join(mdlines, "\n")
end



for pg in va.pages
    pgref = objectcomponent(pg.urn)
    @info("Analyzing $(pgref)...")
    outfile = joinpath(outputdir, pgref * ".md")
    open(outfile, "w") do io
        write(io, pagereport(pg.urn))
    end
end