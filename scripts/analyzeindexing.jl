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

    (md = join(mdlines, "\n"), fail1 = length(dsenotindexed), fail2 = length(indexednotindse))

end

struct PageSummary
    urn::Cite2Urn
    fail1::Integer
    fail2::Integer
end


function summarizeMS(ms; report = true)
    pagesummaries = PageSummary[]
    for pg in ms.pages
        report = pagereport(pg.urn)
        push!(pagesummaries, PageSummary(pg.urn, report.fail1, report.fail2))
    end
    if report
        pgref = objectcomponent(pg.urn)
        @info("Analyzing $(pgref)...")
        outfile = joinpath(outputdir, pgref * ".md")
        open(outfile, "w") do io
            write(io, report.md )
        end
    end
end

summaries = summarizeMS(va)

#=
outfile = joinpath(outputdir, "README.md")
summarymd = """# Summary of indexing errors in Venetus A

- Total scholia indexed in DSE record but **not** linked in XML edition to *Iliad* text on the same page: $(category1fail)
- Total scholia linked in XML edition to *Iliad* text but **not** recorded in DSE record:  $(category2fail)

"""



open(outfile,"w") do io
    write(io, summarymd)
end
=#


summaries |> length

map(summ -> summ.fail1, summaries) |> maximum
map(summ -> summ.fail2, summaries) |> maximum
map(summ -> summ.fail2 + summ.fail1, summaries) |> maximum


byfail1 = sort(summaries, by = pg -> pg.fail1, rev = true)
byfail2 = sort(summaries, by = pg -> pg.fail2, rev = true)
bytotal = sort(summaries, by = pg -> pg.fail1 + pg.fail2, rev = true)

