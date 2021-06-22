using EditorsRepo
using CitableText
using CitableCorpus

archiveroot = string(pwd() |> dirname, "/hmt-archive/archive")
repo = repository(archiveroot; dse="dse-data", config="textconfigs", editions="tei-editions")
#citation = citation_df(repo)

function archivalcorpus(r::EditingRepository)
    citesdf = citation_df(r)
    urns = citesdf[:, :urn]

    corpora = []
    for u in urns
        # 1. Read the source text (here, XML)
        src = textsourceforurn(r, u)
        if isnothing(src)
            # skip it
        else
            # 2. get the EditionBuilder for the urn
            reader = ohco2forurn(citesdf, u)
            # 3. create citable corpus of the archival version
            push!(corpora, reader(src, u))
        end
    end
    CitableCorpus.composite_array(corpora)
end

archivaltexts = archivalcorpus(repo)
archivaltexts.corpus |> length

texts = texturns(repo)
normednodes = []
for t in texts
    nds = normalizednodes(repo, t)
    push!(normednodes, nds)        
end
normed = filter(nodelist -> ! isnothing(nodelist), normednodes) |> Iterators.flatten |> collect |> CitableTextCorpus
normed.corpus |> length
nonempty = filter(cn -> ! isempty(cn.text), normed.corpus)
iliadlines = filter(cn -> contains(cn.urn.urn, "tlg0012"),  nonempty)
schnodes = filter(cn -> contains(cn.urn.urn, "tlg5026"),  nonempty)
schcomments = filter(cn -> endswith(passagecomponent(cn.urn),"comment"), schnodes)
reff = filter(cn -> endswith(passagecomponent(cn.urn), "ref"), normed.corpus)


dse = dse_df(repo)