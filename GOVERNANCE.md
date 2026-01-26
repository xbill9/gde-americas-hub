# Governance - GDE Americas Hub

This document describes the governance model, community roles, and contribution ladder for the GDE Americas Hub project.

## Table of Contents

- [Project Mission](#project-mission)
- [Community Principles](#community-principles)
- [Roles and Responsibilities](#roles-and-responsibilities)
- [Contribution Ladder](#contribution-ladder)
- [Decision Making](#decision-making)
- [Conflict Resolution](#conflict-resolution)

---

## Project Mission

The GDE Americas Hub aims to provide a centralized, high-quality repository of technical content created by and for Google Developer Experts in the Americas region. We are committed to:

- **Quality**: Maintaining high standards for all published content
- **Inclusivity**: Welcoming contributions from all GDEs regardless of expertise area or location
- **Collaboration**: Fostering a supportive environment for knowledge sharing
- **Sustainability**: Building a long-term maintainable knowledge base
- **Impact**: Helping developers across the Americas learn and grow

## Community Principles

All community members must adhere to:

1. **Code of Conduct**: Follow the [Code of Conduct](CODE_OF_CONDUCT.md)
2. **Respectful Communication**: Provide constructive, kind feedback
3. **Quality First**: Prioritize accuracy and clarity in all content
4. **Attribution**: Give credit to sources and contributors
5. **Collaboration**: Work together to improve content iteratively

---

## Roles and Responsibilities

### Contributor

**Definition**: Anyone who contributes content, reviews, or improvements to the hub.

**Requirements**:
- Must be a Google Developer Expert (active or alumni)
- Follow the [Contributing Guidelines](CONTRIBUTING.md)
- Adhere to the Code of Conduct

**Privileges**:
- Submit Pull Requests for content
- Participate in public discussions
- Attend community events

**Responsibilities**:
- Create quality content following templates
- Respond to review feedback
- Test content locally before submission

**How to Become a Contributor**:
- Fork the repository and submit your first PR!
- No formal nomination needed

---

### Reviewer

**Definition**: Trusted community member who reviews and provides feedback on contributions.

**Requirements**:
- ✅ **Active GDE Status**: Must be an active Google Developer Expert
- ✅ **Contribution History**: At least **5 quality contributions** over a period of time, demonstrating:
  - Understanding of content standards
  - Technical accuracy
  - Consistency in participation
- ✅ **Review Track Record**: History of providing constructive feedback on PRs
- ✅ **Community Engagement**: Active participation in discussions or events
- ✅ **Commitment**: Able to review PRs within 7 days

**Privileges**:
- Review and comment on all Pull Requests
- Request changes on submissions
- Participate in reviewer discussions
- Listed in project credits

**Responsibilities**:
- Review PRs within reasonable timeframe (target: 7 days)
- Provide constructive, actionable feedback
- Verify technical accuracy and quality
- Help contributors improve their content
- Stay up-to-date with contribution guidelines

**How to Become a Reviewer**:

1. **Demonstrate Contributions**: Make at least 5 quality contributions (codelabs, blog posts, resources, or substantial improvements)
2. **Build Review History**: Participate in PR discussions with helpful comments
3. **Nomination**: Any Maintainer can nominate you by opening an issue
4. **Approval Process**:
   - Nomination must be seconded by at least one other Maintainer
   - 3-day community feedback period
   - Approved by majority of Maintainers (simple majority)
5. **Acceptance**: Accept the nomination and reviewer responsibilities

**Removal from Role**:
- Inactive for 6 months (no reviews or contributions)
- Violations of Code of Conduct
- Loss of GDE status (automatic removal)
- Personal request

---

### Maintainer

**Definition**: Core team member responsible for project direction, code ownership, and final approval of contributions.

**Requirements**:
- ✅ **Active GDE Status**: Must be an active Google Developer Expert
- ✅ **Reviewer for 3+ Months**: Must have served as a Reviewer for at least 3 months
- ✅ **Sustained Contributions**: At least **15 substantial contributions** to the hub
- ✅ **Broad Knowledge**: Familiarity with multiple areas of the hub
- ✅ **Community Leadership**: Demonstrated ability to mentor and guide contributors
- ✅ **Time Commitment**: Minimum 4 hours per month for maintenance duties

**Privileges**:
- Merge Pull Requests
- Write access to repository
- Vote on governance decisions
- Nominate Reviewers and Maintainers
- Approve releases and major changes
- Manage GitHub issues and projects

**Responsibilities**:
- Review and merge PRs in a timely manner
- Maintain documentation and guidelines
- Ensure quality standards are met
- Mentor Contributors and Reviewers
- Participate in governance decisions
- Monitor project health and sustainability
- Plan and coordinate releases
- Represent the project in the GDE community

**How to Become a Maintainer**:

1. **Serve as Reviewer**: Be an active Reviewer for at least 3 months
2. **Demonstrate Leadership**: Show ability to guide contributors and maintain quality
3. **Build Trust**: Consistent participation and good judgment
4. **Nomination**: Any current Maintainer can nominate you
5. **Approval Process**:
   - Nomination must be seconded by at least two other Maintainers
   - 7-day community feedback period
   - Approved by 2/3 supermajority of current Maintainers
   - Final approval from GDE Americas leadership (if applicable)
6. **Acceptance**: Accept responsibilities and commit to time requirements

**Removal from Role**:
- Inactive for 4 months (no activity)
- Violations of Code of Conduct
- Loss of GDE status (transitions to Reviewer if community agrees)
- Personal request
- Maintainer vote (2/3 supermajority)

---

## Contribution Ladder

Visual representation of the contribution journey:

```
┌─────────────────────────────────────────────────────┐
│                    Maintainer                       │
│  • 15+ contributions                                │
│  • 3+ months as Reviewer                            │
│  • Merge access                                     │
│  • 4 hrs/month commitment                           │
└─────────────────────────────────────────────────────┘
                        ↑
                    (promoted)
                        │
┌─────────────────────────────────────────────────────┐
│                     Reviewer                        │
│  • 5+ quality contributions                         │
│  • Active GDE status                                │
│  • Review PRs within 7 days                         │
└─────────────────────────────────────────────────────┘
                        ↑
                   (nominated)
                        │
┌─────────────────────────────────────────────────────┐
│                   Contributor                       │
│  • Any active or alumni GDE                         │
│  • Submit PRs                                       │
│  • Provide feedback                                 │
└─────────────────────────────────────────────────────┘
```

### Counting Contributions

**What Counts as a Contribution?**

Quality matters more than quantity. Contributions include:

1. **New Content** (high value):
   - Complete codelab
   - Technical blog post (1000+ words)
   - Comprehensive learning path
   - Resource collection with metadata

2. **Substantial Improvements** (medium value):
   - Major content updates or rewrites
   - Adding multiple missing sections
   - Creating content templates
   - Significant documentation improvements

3. **Reviews and Feedback** (medium value):
   - Detailed technical reviews of PRs
   - Testing codelabs and providing feedback
   - Content editing and proofreading

4. **Minor Contributions** (lower value):
   - Typo fixes
   - Small formatting changes
   - Link updates

**Note**: Multiple small contributions may collectively count as one substantial contribution at Maintainer discretion.

---

## Decision Making

### Types of Decisions

**1. Routine Changes** (no approval needed)
- Typo fixes
- Documentation clarifications
- Adding new content following guidelines

**2. Reviewer Approval** (1 Reviewer or Maintainer)
- New codelabs, blog posts, resources
- Minor guideline updates
- Translations

**3. Maintainer Approval** (2 Maintainers)
- Structural changes to the hub
- Changes to contribution guidelines
- New sections or categories
- Governance updates

**4. Major Changes** (Maintainer vote, 2/3 majority)
- Technology stack changes
- Licensing changes
- Significant governance changes
- Repository ownership transfers

### Voting Process

When a vote is required:

1. **Proposal**: Open an issue with `[VOTE]` prefix
2. **Discussion Period**: Minimum 7 days for community feedback
3. **Voting Period**: 7 days for eligible voters
4. **Vote Format**: 👍 (approve), 👎 (reject), 👀 (abstain)
5. **Quorum**: At least 50% of eligible voters must participate
6. **Result**: Based on required threshold (simple majority or 2/3)

---

## Conflict Resolution

### Resolution Process

1. **Direct Communication**: Parties attempt to resolve directly
2. **Maintainer Mediation**: Any Maintainer can mediate if needed
3. **Governance Review**: Maintainers review if unresolved
4. **GDE Leadership Escalation**: Final escalation to GDE Americas leadership
5. **Code of Conduct**: Violations handled per CoC procedures

### Appeals

Decisions can be appealed by:
- Opening an issue with `[APPEAL]` prefix
- Providing rationale for reconsideration
- Maintainer Council reviews within 14 days
- Final decision by 2/3 supermajority vote

---

## Amendments to Governance

This governance document can be amended by:

1. Any Maintainer proposes changes via PR
2. 14-day community feedback period
3. Maintainer Council vote (2/3 supermajority)
4. GDE Americas leadership review (if applicable)

---

## Acknowledgments

This governance model is inspired by successful open source projects:

- [Backstage Community Governance](https://github.com/backstage/community/blob/main/GOVERNANCE.md)
- [Istio Community Roles](https://github.com/istio/community/blob/master/ROLES.md)
- [CNCF Project Governance](https://github.com/cncf/project-template/blob/main/GOVERNANCE-maintainer.md)
- [Open Source Guides](https://opensource.guide/best-practices/)

---

## Questions?

- Open an issue with the `question` label
- Join our community discussions
- Contact the Maintainer Council

**Current Maintainers**: See [MAINTAINERS.md](MAINTAINERS.md)

---

*Last Updated: 2026-01-23*
*Version: 1.0*
