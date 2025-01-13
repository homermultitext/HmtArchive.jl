"""Summary of editing quality for a single page of a MS."""
struct PageSummary
    urn::Cite2Urn
    fail1::Integer
    fail2::Integer
end


"""Compose a Markdown report for a page."""
function pagereport(pg, dse, commentary)


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


"""Summarize results fora ll pages in a MS."""
function summarizeMS(ms, dse, comm; interval = 5)
	pagesummaries = PageSummary[]
    max = length(ms.pages)
	for (i,pg) in enumerate(ms.pages)
		if mod(i,interval) == 0
			@info("Page $(i)/$(max)...")
		end
    	report = pagereport(pg.urn, dse, comm)
    	push!(pagesummaries, PageSummary(pg.urn, report.fail1, report.fail2))
	end
	pagesummaries
end


function cat1histo(v::Vector{PageSummary})
	byfail1 = sort(v, by = pg -> pg.fail1, rev = true)
	xlabels = map(report -> objectcomponent(report.urn), byfail1)
	yvals = map(report -> report.fail1, byfail1)
	bar(xlabels, yvals, title = "Category 1 errors")
end

function cat2histo(v::Vector{PageSummary})
	byfail2 = sort(v, by = pg -> pg.fail2, rev = true)
	xlabels = map(report -> objectcomponent(report.urn), byfail2)
	yvals = map(report -> report.fail2, byfail2)
	bar(xlabels, yvals, title = "Category 2 errors")
end


function cat1bar(v::Vector{PageSummary})
	xlabels = map(report -> objectcomponent(report.urn), v)
	yvals = map(report -> report.fail1, v)
	bar(xlabels, yvals, title = "Category 1 errors byt page (in page order)")
end

function cat2bar(v::Vector{PageSummary})
	
	xlabels = map(report -> objectcomponent(report.urn), v)
	yvals = map(report -> report.fail2, v)
	bar(xlabels, yvals, title = "Category 2 errors by page (in page order)")
end