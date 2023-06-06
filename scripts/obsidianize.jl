using HmtArchive.Analysis

using CitableBase, CitableText, CitableCorpus
using CitableObject
using CitablePhysicalText

basedir = joinpath(pwd(), "obsidian-scratch")

function mdline(psg)
	"`$(passagecomponent(psg.urn))` $(psg.text)" 
end
function yamlhdr(pg, dse)
    texts = textsforsurface(pg.urn, dse)
    iliadlines = filter(u -> startswith(workcomponent(u), "tlg0012.tlg001"), texts)
    aliaslist = map(u -> "iliad " * passagecomponent(u), iliadlines)
    "---\naliases: "   * join(aliaslist, ", ") * "\n---"
end

function formatiliad(psglist::Vector{CtsUrn}, corpus::CitableTextCorpus)
    iliadlines = filter(u -> startswith(workcomponent(u), "tlg0012.tlg001"), psglist)
    if isempty(iliadlines)
        ""
    else
        hdg = "### *Iliad* $(passagecomponent(iliadlines[1]))-$(passagecomponent(iliadlines[end]))"

        mdlines = []
        for ln in iliadlines
            psgs = filter(psg -> dropversion(psg.urn) == dropversion(ln), corpus.passages)
           	length(psgs) == 1 ? push!(mdlines, mdline(psgs[1])) : push!(mdlines, "?($(passagecomponent(ln)))?")
        end
        hdg * "\n\n" * join(mdlines, "\n\n")
    end

end


function formatpage(pg, dse, corpus)

    texts = textsforsurface(pg.urn, dse)
    iliad = formatiliad(texts, corpus)

    # add scholia
    scholia = ""
    join([iliad, scholia], "\n\n")
end

"""Write an Obsidian vault in directory `dir`
for the manuscript `ms`.
"""    
function obsidianize(ms, dir)
    outputdir = joinpath(dir, collectionid(urn(ms)))
    mkpath(outputdir)
    dserecords = hmt_dse()[1]
    dipltext = hmt_diplomatic()

    
	for pg in ms.pages#[25:30]
        @info("Page: $(objectcomponent(pg.urn))")
        yaml = yamlhdr(pg, dserecords)
        title =  "## $(label(ms)), folio $(objectcomponent(pg.urn))"
        body = formatpage(pg, dserecords, dipltext)
   
		fname = pagename(pg.urn, outputdir)
		open(fname, "w") do io
			write(io,join([yaml, title, body], "\n\n"))
		end
	end
end


"""Generate markdown file name to use for page in Obsidian vault."""
function pagename(u::Cite2Urn, dir)
	joinpath(dir, objectcomponent(u) * ".md")
end


mss = hmt_codices()
vaurn = Cite2Urn("urn:cite2:hmt:msA.v1:")
va = filter(ms -> urn(ms) == vaurn, mss)[1]

@time obsidianize(va, basedir)